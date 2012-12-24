class Shopping::Cart < ActiveRecord::Base

  belongs_to :email, class_name: 'Admin::Customer::Email'
  has_many :items, class_name: 'Shopping::Item', dependent: :destroy, order: 'offer_id DESC'
  has_one :purchase, class_name: 'Shopping::Purchase', dependent: :destroy
  has_one :address, class_name:'Shopping::Address', dependent: :destroy
  has_one :shipping, class_name: 'Shopping::Shipping', dependent: :destroy

  attr_accessible :items, :items_attributes,
                  :purchase, :purchase_attributes,
                  :address, :address_attributes,
                  :shipping, :shipping_attributes,
                  :email, :email_attributes,
                  :tracking

  accepts_nested_attributes_for :items, :purchase, :address, :email, :shipping

  scope :not_recent, lambda {where(" created_at < ? ", 2.hours.ago)}

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

  def taxable_sub_total
    items.each do |item|
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
    sub_total = items.inject(0) {|result, item| result + item.extension} if purchase.present?
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
    items.inject(0) { |result, item| result + item.quantity.to_i }
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

end