class Admin::Merchandise::Piece < ActiveRecord::Base
  attr_accessible :remote_image_url, :name, :image,
                  :short_description, :long_description,
                  :sku, :price,
                  :active, :featured, :deleted_at

  has_many :offers, :class_name => 'Admin::Email::Offer'

  mount_uploader :image, ImageUploader
end
