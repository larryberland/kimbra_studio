class Shopping::Address < ActiveRecord::Base
  belongs_to :state
  belongs_to :cart, :class_name => 'Shopping::Cart'

  attr_accessible :cart_id, :cart,
                  :first_name, :last_name,
                  :address1, :address2, :city, :state, :state_id, :zip_code,
                  :email

  accepts_nested_attributes_for :cart

  validates_presence_of :cart
  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :address1
  validates_presence_of :city
  validates_presence_of :state
  validates_presence_of :zip_code
  validates_presence_of :email

  before_save :check

  private #=================================================================================

  def check
    puts "save=>#{self.inspect}"
  end

end