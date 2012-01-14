class Admin::Customer::Offer < ActiveRecord::Base
  attr_accessible :image, :remote_image_url
  belongs_to :piece, :class_name => 'Admin::Merchandise::Piece'
  belongs_to :portrait, :class_name => 'MyStudio::Portrait'
  belongs_to :email, :class_name => 'Admin::Customer::Email'
  mount_uploader :image, ImageUploader
end
