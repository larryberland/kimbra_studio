class Shopping::Purchase < ActiveRecord::Base

  @@seeds = false

  serialize :tax_description

  belongs_to :cart, :class_name => 'Shopping::Cart'
  has_one :stripe_card, :class_name => 'Shopping::StripeCard'

  attr_accessible :cart, :cart_id,
                  :total_cents, :purchased_at,
                  :stripe_card_token, :stripe_response_id, :stripe_paid, :stripe_fee

  accepts_nested_attributes_for :stripe_card

  validate :stripe_info
  before_create :stripe_payment

  def confirmation_code
    @confirmation_code ||= stripe_response_id.split('_').last if stripe_response_id
  end

  def total
    calculate_cart_tax
    cart.total
  end

  def calculate_cart_tax
    self.tax = 0
    self.tax_description = Hash.new(
        zip_code: cart.address.zip_code,
        taxable_amount: cart.taxable_sub_total,
        state: cart.address.zip_code,
        region: '',
        code: '',
        combined_tax: {rate: 0, amount: 0},
        state_tax: {rate: 0, amount: 0},
        county_tax: {rate: 0, amount: 0},
        city_tax: {rate: 0, amount: 0},
        special_tax: {rate: 0, amount: 0})
    tax_rate = ZipCodeTax.find_by_zip_code(cart.address.zip_code.strip)
    if tax_rate
      state_tax = (cart.taxable_sub_total * tax_rate.state_rate).round(2)
      county_tax = (cart.taxable_sub_total * tax_rate.county_rate).round(2)
      city_tax = (cart.taxable_sub_total * tax_rate.city_rate).round(2)
      special_tax = (cart.taxable_sub_total * tax_rate.special_rate).round(2)
      combined_tax = state_tax + county_tax + city_tax + special_tax
      self.tax_description = {
          zip_code: tax_rate.zip_code,
          taxable_amount: cart.taxable_sub_total,
          state: tax_rate.state,
          region: tax_rate.tax_region_name,
          code: tax_rate.tax_region_code,
          combined_tax: {rate: tax_rate.combined_rate, amount: combined_tax},
          state_tax: {rate: tax_rate.state_rate, amount: state_tax},
          county_tax: {rate: tax_rate.county_rate, amount: county_tax},
          city_tax: {rate: tax_rate.city_rate, amount: city_tax},
          special_tax: {rate: tax_rate.special_rate, amount: special_tax}
      }
      self.tax = combined_tax
    end
  end

  def tax_short_description
    if tax
      "#{tax_description[:region]} @ #{tax_description[:combined_tax][:rate] * 100}%"
    else
      'no taxable region'
    end
  end

  private #=================================================================================

  def stripe_info
    errors.add(:card_number, "Missing stripe token") if stripe_card_token.nil?
    errors.empty?
  end

  def stripe_description
    # TODO  "Charge for #{t(:stripe_description_prefix)}... for #{cart.email}"
    "Charge for Kimbra Studios... for #{cart.email}"
  end

  def create_stripe_card(stripe_card_hash)
    attrs = stripe_card_hash.merge(:purchase => self)
    attrs[:stripe_object] = attrs.delete(:object)
    attrs[:stripe_type] = attrs.delete(:type)
    self.stripe_card = Shopping::StripeCard.new(attrs)
  end

  def stripe_payment
    # require "stripe"
    # Stripe.api_key = ACADIA_CONFIG[:stripe][:test_key]
    unless @@seeds
      res = Stripe::Charge.create(:amount => (total * 100).to_i, # 400
                                  :currency => "usd",
                                  :card => stripe_card_token, #"tok_kUUs1tA5OWvkO4", obtained with stripe.js
                                  :description => stripe_description)
      puts "response=>#{res.inspect}"
      self.stripe_response_id = res['id']
      self.stripe_paid = res['paid']
      self.stripe_fee = res['fee']
      create_stripe_card(res['card'].to_hash)
    else
      #self.stripe_response_id = schedule.id.to_s
      self.stripe_paid = 'true'
      self.stripe_fee = 40
    end
    self.purchased_at = Time.now
    true
  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while creating payment: #{e.message}"
    errors.add :base, "There was a problem with your credit card."
    false
  end

end