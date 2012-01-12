class Admin::Merchandise::Piece < ActiveRecord::Base
  attr_accessible :remote_image_url, :name, :image,
                  :short_description, :long_description,
                  :sku, :price,
                  :active, :featured, :deleted_at

  mount_uploader :image, ImageUploader
end
