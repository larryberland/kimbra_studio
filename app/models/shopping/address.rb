class Shopping::Address < ActiveRecord::Base
  belongs_to :state
  belongs_to :cart, :class_name => 'Shopping::Cart'

  attr_accessible :cart_id, :cart,
                  :first_name, :last_name,
                  :address1, :address2, :city, :state, :state_id, :zip_code,
                  :email, :email_confirmation, :phone, :country

  attr_accessor :name, :state_stripe, :country_stripe, :email_confirmation

  accepts_nested_attributes_for :cart

  validates_presence_of :cart
  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :address1
  validates_presence_of :city
  validates_presence_of :state
  validates_presence_of :zip_code
  validates_presence_of :email, :email => true
  validates_confirmation_of :email

  before_save :check

  def name
    "#{first_name} #{last_name}"
  end

  def phone_number=(num)
    super num.to_s[0,10].gsub(/\D/,'')
  end

  def state_stripe
    state.try(:stripe)
  end

  def country_stripe
    state.try(:country).try(:stripe)
  end

  def zip_code_5_digit
    zip_code.to_s.strip[0..4]
  end

  private #=================================================================================

  def check
    puts "save=>#{self.inspect}"
  end

end