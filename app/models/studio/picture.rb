class Studio::Picture < ActiveRecord::Base
  attr_accessible :description, :file_name, :image
  belongs_to :shoot
  mount_uploader :image, ImageUploader
end
