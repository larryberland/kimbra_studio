class Shopping::Shipping < ActiveRecord::Base

  belongs_to :cart, :class_name => 'Shopping::Cart'

  attr_accessible :cart_id, :cart,
                  :shipping_option, :tracking, :total_cents

  # Note that :shipping_option is not a foreign key here. That's because shipping options will change over
  # time (names, descriptions and prices) and we do not want/need to maintain an audit trail of these.
  # So, all we are doing is using ShippingOption as a reference table of the values (as opposed to row ids)
  # to be inserted into the fields here. That way, ShippingOptions can change in the future but older
  #values in this Shipping table are not (incorrectly) updated. Clear as mud?

  accepts_nested_attributes_for :cart

  validates_presence_of :cart
  validates_presence_of :shipping_option
  validates_presence_of :total_cents

  private #=======================================================

end