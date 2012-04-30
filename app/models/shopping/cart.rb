class Shopping::Cart < ActiveRecord::Base

  SHIPPING_PRICE = 9.95

  # TODO add real shipping options.
  #Regular Ground Shipping USA   $9.95
  #2nd Day Air Shipping USA    $24.95
  #Next Day Air Shipping USA     $32.95
  #Alaska Shipping  $25.00
  #Canada Shipping  $26.95
  #Hawaii Shipping  $25.00
  #Mexico Shipping $32.95
  #Outside USA, Mexico and Canada $48.00

  belongs_to :email, :class_name => 'Admin::Customer::Email'
  has_many :items, :class_name => 'Shopping::Item'
  has_one :purchase, :class_name => 'Shopping::Purchase'
  has_one :address, :class_name => 'Shopping::Address'

  attr_accessible :items, :items_attributes,
                  :purchase, :purchase_attributes,
                  :address, :address_attributes,
                  :email, :email_attributes,
                  :tracking

  accepts_nested_attributes_for :items, :purchase, :address, :email

  before_create :set_tracking

  def to_param
    tracking
  end

  def total
    items.each do |item|
      raise 'missing price in offer=>#{item.offer.inspect) piece=>#{item.offer.piece.id}' if item.offer.piece.price.nil?
    end
    total = items.inject(0) { |result, item| result + (item.offer.piece.price * item.quantity.to_i) }
    total += SHIPPING_PRICE
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