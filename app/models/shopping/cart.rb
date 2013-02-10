class Shopping::Cart < ActiveRecord::Base

  serialize :tax_description

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
                  :tracking,
                  :invoice_items_amount,
                  :invoice_tax_amount,
                  :tax_description,
                  :invoice_amount,
                  :commission_amount # on purchase paid_amount that is taxable in_cents

  accepts_nested_attributes_for :items, :purchase, :address, :email, :shipping

  attr_accessor :shipping_changed, :address_changed, :items_changed

  scope :not_recent, lambda { where(" created_at < ? ", 2.hours.ago) }

  before_create :set_tracking
  before_save :prepare_invoice

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

  def tax_short_description
    if invoice_tax_amount > 0
      "#{tax_description[:region]} @ #{(tax_description[:combined_tax][:rate] * 100).round(2)}%"
    else
      'no sales tax'
    end
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

  # deprecated for invoice_total
  def xtotal
    # currently this is a total before a stripe payment has been
    #  made. thinking purchase will always be nil
    total = taxable_sub_total
    total += shipping.total if shipping
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

  # total represents value in dollars
  def invoice_items_total
    invoice_items_amount / 100.0
  end

  def invoice_tax_total
    invoice_tax_amount / 100.0
  end

  def invoice_shipping_total
    shipping.try(:total).to_f
  end

  def invoice_total
    invoice_amount / 100.0
  end


  private #========================================================================

  def set_tracking
    self.tracking = UUID.random_tracking_number if tracking.nil?
  end

  def invoice_shipping_amount
    shipping.try(:amount).to_i
  end

  # invoice amount in cents for all items in the cart with
  #   their quantity and price
  def invoice_items
    Rails.logger.info("cart:#{id} has #{items.size} items")
    items.each do |item|
      if item.offer.nil?
        Rails.logger.warn("Missing offer in item=>#{item.inspect}")
        puts("Missing offer in item=>#{item.inspect}")
        item.destroy
      elsif item.offer.piece.nil?
        Rails.logger.warn("Missing piece in offer=>#{item.offer.inspect}")
        raise "missing piece in offer=>#{item.offer.inspect}"
      elsif item.offer.piece.price.nil?
        Rails.logger.warn "missing price in offer=>#{item.offer.inspect} piece=>#{item.offer.piece.id}"
        raise "missing price in offer=>#{item.offer.inspect} piece=>#{item.offer.piece.id}"
      end
    end
    # amount in cents of all items with their quantity
    self.invoice_items_amount = items.collect { |r| r.invoice_amount }.sum
    self.invoice_items_amount
  end

  # calculate and set our invoice_tax_amount in cents
  #   and our tax description based on the cart's current address
  # NOTE: make sure you call invoice_items before this for proper calculation
  def invoice_tax
    if address.present?
      self.invoice_tax_amount, self.tax_description = address.invoice_tax(invoice_items_amount)
    else
      self.invoice_tax_amount = 0
    end
    self.invoice_tax_amount
  end

  def prepare_invoice

    invoice_items # currently always calculate items, we should change this to items_changed

    if (shipping_changed || address_changed)

      puts "prepare_invoice() calling calculating invoice"
      invoice_tax

      if (shipping.present? and address.present?)
        # do not set invoice_amount until we have address and shipping info
        self.invoice_amount = invoice_items_amount + invoice_tax_amount + invoice_shipping_amount
      else
        self.invoice_amount = 0
      end
    end
    true
  end


end