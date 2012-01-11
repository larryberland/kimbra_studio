class Studio::Picture < ActiveRecord::Base
  attr_accessible :description, :file_name, :image  # TODO: don't think we need this?'
  belongs_to :shoot
  mount_uploader :image, ImageUploader
end
