class Shopping::Cart < ActiveRecord::Base

  belongs_to :email, class_name: 'Admin::Customer::Email'
  has_many :items, class_name: 'Shopping::Item', dependent: :destroy, order: 'offer_id DESC'
  has_one :purchase, class_name: 'Shopping::Purchase', dependent: :destroy
  has_one :address, class_name: 'Shopping::Address', dependent: :destroy
  has_one :shipping, class_name: 'Shopping::Shipping', dependent: :destroy

  attr_accessible :items, :items_attributes,
                  :purchase, :purchase_attributes,
                  :address, :address_attributes,
                  :shipping, :shipping_attributes,
                  :email, :email_attributes,
                  :tracking

  accepts_nested_attributes_for :items, :purchase, :address, :email, :shipping

  scope :not_recent, lambda { where(" created_at < ? ", 2.hours.ago) }

  before_create :set_tracking

  def find_item(offer_id)
    items.where(offer_id: offer_id).first
  end

  def has_offer?(offer_id)
    @in_cart ||= items.collect(&:offer_id)
    @in_cart.include?(offer_id)
  end

  def to_param
    tracking
  end

  # calculate the purchase attributes info
  #   we are going to submit to Stripe and
  #   then save in our purchase record
  def stripe_invoice_amount
    purchase_attrs                                         = {}
    # total of items
    purchase_attrs[:items]                                 = invoice_items

    # total tax based on cart Address zip_code
    purchase_attrs[:tax], purchase_attrs[:tax_description] = invoice_tax(purchase_attrs[:items])

    # total for shipping option
    purchase_attrs[:shipping]                              = invoice_shipping

    # total to charge the Stripe account
    purchase_attrs[:amount]                                = [:items, :tax, :shipping].collect { |key| purchase_attrs[key].to_f }.sum

    purchase_attrs
  end

  # refactor this in items_total above
  def taxable_sub_total
    Rails.logger.info "taxable_sub_total() cart#{self.inspect}"
    Rails.logger.info "taxable_sub_total() purchase#{purchase.inspect}"

    items.each do |item|
      puts "offer_piece:#{item.offer.piece.inspect}"
      if item.offer.nil?
        Rails.logger.warn("Missing offer in item=>#{item.inspect}")
        item.destroy
        #raise "missing offer in item=>#{item.inspect}"
      elsif item.offer.piece.nil?
        Rails.logger.warn("Missing piece in offer=>#{item.offer.inspect}")
        raise "missing piece in offer=>#{item.offer.inspect}"
      elsif item.offer.piece.price.nil?
        Rails.logger.warn "missing price in offer=>#{item.offer.inspect} piece=>#{item.offer.piece.id}"
        raise "missing price in offer=>#{item.offer.inspect} piece=>#{item.offer.piece.id}"
      end
    end
    Rails.logger.info("cart:total()\ncart.purchase:#{purchase.inspect}")
    sub_total = items.inject(0) { |result, item| result + item.extension } if purchase.present?
    sub_total ||= 0.0
    sub_total
  end

  def total
    total = taxable_sub_total
    total += (shipping.total_cents / 100.0) if shipping
    total += purchase.tax if purchase
    total
  end

  def quantity
    items.collect { |item| item.quantity.to_i }.sum
  end

          # Display this like:  "$%.2f" % Shopping::Cart.first.commission  => "$2.80"
  def commission
    (taxable_sub_total * email.my_studio_session.studio.info.commission_rate.to_i).round(2)
  end

  def shipment_at
    shipping ? shipping.updated_at : nil
  end

  private #========================================================================

  def set_tracking
    self.tracking = UUID.random_tracking_number if tracking.nil?
  end

  # refactor taxable_sub_total to total all items in the cart
  #   with their quantity and price information
  #   has nothing to do with tax or not
  # NOTE:
  #   This is called from purchase before_create to calculate what
  #     we are sending to stripe for the charge
  def invoice_items
    Rails.logger.info("cart:#{id} has #{items.size} items")
    items.each do |item|
      if item.offer.nil?
        Rails.logger.warn("Missing offer in item=>#{item.inspect}")
        item.destroy
      elsif item.offer.piece.nil?
        Rails.logger.warn("Missing piece in offer=>#{item.offer.inspect}")
        raise "missing piece in offer=>#{item.offer.inspect}"
      elsif item.offer.piece.price.nil?
        Rails.logger.warn "missing price in offer=>#{item.offer.inspect} piece=>#{item.offer.piece.id}"
        raise "missing price in offer=>#{item.offer.inspect} piece=>#{item.offer.piece.id}"
      end
    end
    items_total = items.collect { |r| r.invoice_total }.sum
    items_total ||= 0.0
    items_total
  end

  def invoice_shipping
    shipping_total = (shipping.total_cents / 100.0) if shipping
    shipping_total ||= 0.0
    shipping_total
  end

  def invoice_tax(taxable_sub_total)
    raise "we need an address to figure this?" if address.nil?
    return address.invoice_tax(taxable_sub_total)
  end

end