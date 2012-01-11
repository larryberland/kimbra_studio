class Studio::Picture < ActiveRecord::Base
  attr_accessible :description, :image, :remote_image_url
  belongs_to :shoot
  mount_uploader :image, ImageUploader
end
