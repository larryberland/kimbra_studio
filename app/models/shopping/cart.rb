class Shopping::Cart < ActiveRecord::Base

  SHIPPING_PRICE = 10.0

  belongs_to :showroom, :class_name => 'Minisite::Showroom'
  has_many :items, :class_name => 'Shopping::Item'
  has_one :purchase, :class_name => 'Shopping::Purchase'
  has_one :address, :class_name => 'Shopping::Address'

  attr_accessible :items, :items_attributes,
                  :purchase, :purchase_attributes,
                  :address, :address_attributes,
                  :showroom, :showroom_attributes
  accepts_nested_attributes_for :items, :purchase, :address, :showroom

  def to_total
    items.each do |item|
      raise 'missing price in offer=>#{item.offer.inspect) piece=>#{item.offer.piece.id}' if item.offer.piece.price.nil?
    end
    total = items.collect{|item| item.offer.piece.price}.sum
    total += SHIPPING_PRICE
    total
  end

end
