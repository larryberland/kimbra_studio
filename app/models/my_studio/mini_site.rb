class MyStudio::MiniSite < ActiveRecord::Base
  attr_accessible :image, :remote_image_url
  belongs_to :studio
  mount_uploader :image, ImageUploader
end
