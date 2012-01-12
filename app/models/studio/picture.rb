class Studio::Picture < ActiveRecord::Base
  attr_accessible :description, :image, :remote_image_url

  belongs_to :shoot
  has_many :offers, :class_name => 'Admin::Email::Offer'

  mount_uploader :image, ImageUploader
end
