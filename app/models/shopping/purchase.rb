class Shopping::Purchase < ActiveRecord::Base

  @@seeds = false

  belongs_to :cart, class_name: 'Shopping::Cart'
  has_one :stripe_card, class_name: 'Shopping::StripeCard'

  attr_accessor :stripe_create_token_response, :stripe_create_token_status

  attr_accessible :cart, :cart_id, :purchased_at,
                  :invoice_amount,   # cart total in cents before calling stripe
                  :paid_amount,      # cart total in cents after calling stripe Charge Create
                  :stripe_card_token, :stripe_response_id, :stripe_paid, :stripe_fee,
                  :stripe_create_token_response,
                  :stripe_create_token_status

  accepts_nested_attributes_for :stripe_card

  validates :cart, presence: true
  validate :stripe_info

  before_create :stripe_payment

  def paid_total
    paid_amount / 100.0
  end

  def confirmation_code
    @confirmation_code ||= stripe_response_id.split('_').last if stripe_response_id
  end

  private #=================================================================================

  def stripe_info
    # validate we have a stripe_card_token returned from Stripe
    errors.add(:card_number, "Missing stripe token") if stripe_card_token.nil?
    errors.empty?
  end

  def stripe_description
    "#{cart.try(:email).try(:my_studio_session).try(:studio).try(:name)} for #{cart.try(:address).try(:email)} order:#{cart.try(:tracking)}"
  end

  def create_stripe_card(stripe_card_hash)
    attrs                 = stripe_card_hash.merge(:purchase => self)
    attrs[:stripe_object] = attrs.delete(:object)
    attrs[:stripe_type]   = attrs.delete(:type)
    self.stripe_card      = Shopping::StripeCard.new(attrs)
  end

  # before_create callback to send the purchase amount to Stripe
  #   and confirm payment
  def stripe_payment
    Rails.logger.info("STRIPE::stripe_payment() BEGIN")
    raise "must have a cart purchase:#{self.inspect}" if cart.nil?
    # NOTE: hoping cart is taking care of itself to always
    #       have the invoice_amount up to date
    self.invoice_amount = cart.invoice_amount
    raise "must have a cart invoice_amount:#{self.inspect}" if invoice_amount < 1
    unless @@seeds
      Rails.logger.info("STRIPE::amount_in_cents:#{invoice_amount}")
      res = Stripe::Charge.create(:amount      => invoice_amount, # 400
                                  :currency    => "usd",
                                  :card        => stripe_card_token, #"tok_kUUs1tA5OWvkO4", obtained with stripe.js
                                  :description => stripe_description)
      Rails.logger.info("STRIPE:response=>#{res.inspect}")
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
    self.paid_amount = invoice_amount  #  the invoice was paid and we are good to go
    raise "Purchase amount issue #{self.inspect}" if paid_amount < 1
    true
  rescue Stripe::InvalidRequestError => e
    logger.error "STRIPE:: error in purchase#stripe_payment() info=>#{e.message}"
    errors.add :base, "There was a problem with your credit card."
    false
  end

end