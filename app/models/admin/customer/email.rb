class Admin::Customer::Email < ActiveRecord::Base
  belongs_to :my_studio_session, :class_name => 'MyStudio::Session'
  has_many :offers, :class_name => 'Admin::Customer::Offer', :dependent => :destroy
end
