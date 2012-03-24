class Shopping::Cart < ActiveRecord::Base
  belongs_to :showroom, :class_name => 'Minisite::Showroom'
  has_many :items, :class_name => 'Shopping::Item'
  has_one :purchase, :class_name => 'Shopping::Purchase'
  has_one :address, :class_name => 'Shopping::Address'

  attr_accessible :items, :items_attributes,
                  :purchase, :purchase_attributes,
                  :address, :address_attributes,
                  :showroom, :showroom_attributes
  accepts_nested_attributes_for :items, :purchase, :address, :showroom


end
