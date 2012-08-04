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

  def to_param
    tracking
  end

  def taxable_sub_total
    items.each do |item|
      raise 'missing price in offer=>#{item.offer.inspect) piece=>#{item.offer.piece.id}' if item.offer.piece.price.nil?
    end
    items.inject(0) { |result, item| result + item.extension }
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

  private #========================================================================

  def set_tracking
    self.tracking = UUID.random_tracking_number if tracking.nil?
  end

end