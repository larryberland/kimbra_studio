class Admin::Email::Offer < ActiveRecord::Base
  attr_accessible :image, :remote_image_url
  belongs_to :piece, :class_name => "Admin::Merchandise::Piece"
  belongs_to :studio_picture, :class_name => "Studio::Picture"
  mount_uploader :image, ImageUploader
end
