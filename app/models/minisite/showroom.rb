class Minisite::Showroom < ActiveRecord::Base

  belongs_to :studio
  belongs_to :client, :class_name => "MyStudio::Client"
  belongs_to :email, :class_name => "Admin::Customer::Email"

  has_one :cart, :class_name => 'Shopping::Cart'

  attr_accessible :studio, :studio_attributes,
                  :client, :client_attributes,
                  :email, :email_attributes,
                  :cart, :cart_attributes

  accepts_nested_attributes_for :studio, :client, :email, :cart

  before_create :setup_shopping_cart

  def self.generate(studio, client, email)
    Minisite::Showroom.create(:studio   => studio,
                              :client   => client,
                              :email    => email)
  end

  private #==============================================================================

  def setup_shopping_cart
    self.cart ||= Shopping::Cart.new
  end

end