class Minisite::Showroom < ActiveRecord::Base

  belongs_to :offer, :class_name => "Admin::Customer::Offer"
  belongs_to :client, :class_name => "MyStudio::Client"
  belongs_to :studio

  attr_accessible :offer, :offer_attributes,
                 :studio, :studio_attributes,
                 :client, :client_attributes

  accepts_nested_attributes_for :offer, :studio, :client

  def self.generate(offer, studio, client)
    Minisite::Showroom.create(:offer => offer, :studio => studio, :client => client)
  end

end