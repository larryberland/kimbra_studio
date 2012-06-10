class Shopping::Purchase < ActiveRecord::Base

  @@seeds = false

  belongs_to :cart, :class_name => 'Shopping::Cart'
  has_one :stripe_card, :class_name => 'Shopping::StripeCard'

  attr_accessible :cart, :cart_id,
                  :tax, :total, :total_cents, :purchased_at,
                  :stripe_card_token, :stripe_response_id, :stripe_paid, :stripe_fee, :cart_total

  attr_accessor :cart_total

  accepts_nested_attributes_for :stripe_card

  validate :stripe_info
  before_create :stripe_payment

  def confirmation_code
    @confirmation_code ||= stripe_response_id.split('_').last if stripe_response_id
  end

  def cart_total
    cart.total
  end

  # TODO calculate tax if address is in Colorado!
  def calculate_total
    calculate_cart_tax
    cart_total + tax.to_f + cart.shipping.total_cents.to_i / 100.0
  end

  private #=================================================================================

  def calculate_cart_tax
    tax_rate = ZipCodeTax.find_by_zip_code(cart.address.zip_code.strip).try(:combined_rate)
    self.tax = (cart_total * tax_rate).round(2) if tax_rate
  end

  def stripe_info
    errors.add(:card_number, "Missing stripe token") if stripe_card_token.nil?
    errors.empty?
  end

  def stripe_description
    # TODO  "Charge for #{t(:stripe_description_prefix)}... for #{cart.email}"
    "Charge for Kimbra Studios... for #{cart.email}"
  end

  def create_stripe_card(stripe_card_hash)
    attrs                 = stripe_card_hash.merge(:purchase => self)
    attrs[:stripe_object] = attrs.delete(:object)
    attrs[:stripe_type]   = attrs.delete(:type)
    self.stripe_card      = Shopping::StripeCard.new(attrs)
  end

  def stripe_payment
    # require "stripe"
    # Stripe.api_key = ACADIA_CONFIG[:stripe][:test_key]
    unless @@seeds
      res = Stripe::Charge.create(:amount      => (calculate_total * 100).to_i, # 400
                                  :currency    => "usd",
                                  :card        => stripe_card_token, #"tok_kUUs1tA5OWvkO4", obtained with stripe.js
                                  :description => stripe_description)
      puts "response=>#{res.inspect}"
      self.stripe_response_id = res['id']
      self.stripe_paid        = res['paid']
      self.stripe_fee         = res['fee']
      create_stripe_card(res['card'].to_hash)
    else
      #self.stripe_response_id = schedule.id.to_s
      self.stripe_paid = 'true'
      self.stripe_fee  = 40
    end
    self.purchased_at = Time.now
    true
  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while creating payment: #{e.message}"
    errors.add :base, "There was a problem with your credit card."
    false
  end

end