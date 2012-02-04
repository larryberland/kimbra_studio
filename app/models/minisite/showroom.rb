class Minisite::Showroom < ActiveRecord::Base
  belongs_to :offer, :class_name => 'Admin::Customer::Offer'
  belongs_to :customer, :class_name => 'Admin::Customer'
  belongs_to :studio

  attr_accessible :offer_attributes, :customer_attributes, :studio_attributes

end