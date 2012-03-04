class Minisite::Showroom < ActiveRecord::Base

  belongs_to :offer, :class_name => "Admin::Customer::Offer"
  belongs_to :client, :class_name => "MyStudio::Client"
  belongs_to :studio
  belongs_to :email, :class_name => "Admin::Customer::Email"

  attr_accessible :offer, :offer_attributes,
                 :studio, :studio_attributes,
                 :client, :client_attributes,
                 :email,  :email_attributes,
                 :tracking

  accepts_nested_attributes_for :offer, :studio, :client, :email

  def self.generate(offer, studio, client, email)
    tracking = UUID.random_tracking_number
    Minisite::Showroom.create(:offer => offer,
                              :studio => studio,
                              :client => client,
                              :email => email,
                              :tracking => tracking)
  end

  def to_param
    tracking
  end

end