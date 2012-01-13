class Admin::Customer::Email < ActiveRecord::Base
  belongs_to :shoot, :class_name => 'Studio::Shoot'
  has_many :offers, :class_name => 'Admin::Customer::Offer'
end
