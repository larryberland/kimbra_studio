class Admin::Merchandise::Piece < ActiveRecord::Base
  attr_accessible :image, :remote_image_url,
                  :name, :short_description, :long_description,
                  :sku, :price,
                  :active, :featured, :deleted_at

  mount_uploader :image, ImageUploader

  has_many :offers, :class_name => 'Admin::Email::Offer'
  has_many :parts, :class_name => 'Admin::Merchandise::Part', :dependent => :destroy

  scope :pick, lambda{|previous_picks| where('id not in (?)', previous_picks)}


end
