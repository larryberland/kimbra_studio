class Shopping::Address < ActiveRecord::Base
  belongs_to :state
  belongs_to :cart, :class_name => 'Shopping::Cart'

  attr_accessible :cart_id, :cart,
                  :first_name, :last_name,
                  :address1, :address2, :city, :state, :state_id, :zip_code,
                  :email

  attr_accessor :name, :state_name, :country_name

  accepts_nested_attributes_for :cart

  validates_presence_of :cart
  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :address1
  validates_presence_of :city
  validates_presence_of :state
  validates_presence_of :zip_code
  validates_presence_of :email, :email => true

  before_save :check

  def name
    "#{first_name} #{last_name}"
  end

  def phone=(ph)
    phone = ph.gsub(/\D/, '')
  end

  def state_name
    state.try(:name)
  end

  def country_name
    state.try(:country).try(:name)
  end

  private #=================================================================================

  def check
    puts "save=>#{self.inspect}"
  end

end