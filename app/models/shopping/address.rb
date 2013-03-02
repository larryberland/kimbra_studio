class Shopping::Address < ActiveRecord::Base
  belongs_to :state
  belongs_to :cart, class_name: 'Shopping::Cart'

  attr_accessible :cart_id, :cart,
                  :email, :email_confirmation, :phone,
                  :first_name, :last_name,
                  :address1, :address2, :city, :zip_code,
                  :state, :state_id,
                  :country

  attr_accessor :name, :state_stripe, :country_stripe, :email_confirmation

  accepts_nested_attributes_for :cart

  validates :first_name, :last_name, :address1, :city, :state, :zip_code, :cart, presence: true
  validates_presence_of :email, email: true
  validates_confirmation_of :email

  before_save :address_change
  after_save :update_cart_invoice

  def name
    "#{first_name} #{last_name}"
  end

  def phone_number=(num)
    super num.to_s[0, 10].gsub(/\D/, '')
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

  # calculate the invoice tax based on this address information
  def invoice_tax(taxable_sub_total)
    ZipCodeTax.invoice_tax(zip_code_5_digit, taxable_sub_total)
  end

  def address_change
    puts "Address zip_code_changed?#{zip_code_changed?}"
    @update_cart_invoice = zip_code_changed?
    true
  end

  def update_cart_invoice
    puts "Address update_cart_invoice?#{@update_cart_invoice}"
    if @update_cart_invoice
      cart.address_changed = true
      cart.save
    end
  end

end