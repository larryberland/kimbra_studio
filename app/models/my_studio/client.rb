class MyStudio::Client < ActiveRecord::Base

  attr_accessible :name, :email, :phone_number
  has_many :sessions, class_name: 'MyStudio::Session', dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true

end