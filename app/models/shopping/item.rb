class Shopping::Item < ActiveRecord::Base

  belongs_to :cart, :class_name => 'Shopping::Cart'
  belongs_to :offer, :class_name => 'Admin::Customer::Offer'

  attr_accessible :offer, :offer_attributes, :offer_id,
                 :cart,   :cart_attributes, :cart_id

  accepts_nested_attributes_for :offer, :cart

end
