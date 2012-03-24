class Minisite::Showroom < ActiveRecord::Base

  belongs_to :studio
  belongs_to :offer, :class_name => "Admin::Customer::Offer"
  belongs_to :client, :class_name => "MyStudio::Client"
  belongs_to :email, :class_name => "Admin::Customer::Email"

  has_one :cart, :class_name => 'Shopping::Cart'

  attr_accessible :offer, :offer_attributes,
                  :studio, :studio_attributes,
                  :client, :client_attributes,
                  :email, :email_attributes,
                  :cart, :cart_attributes,
                  :tracking

  accepts_nested_attributes_for :offer, :studio, :client, :email, :cart

  before_create :setup_shopping_cart

  def self.generate(offer, studio, client, email)
    tracking = UUID.random_tracking_number
    Minisite::Showroom.create(:offer    => offer,
                              :studio   => studio,
                              :client   => client,
                              :email    => email,
                              :tracking => tracking)
  end

  def to_param
    tracking
  end

  private

  def setup_shopping_cart
    self.cart ||= Shopping::Cart.new
  end

end