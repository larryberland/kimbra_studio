class Admin::Merchandise::Piece < ActiveRecord::Base
  attr_accessible :remote_image_url, :name, :image,
                  :short_description, :long_description,
                  :sku, :price,
                  :active, :featured, :deleted_at

  has_many :offers, :class_name => 'Admin::Email::Offer'
  has_many :parts, :class_name => 'Admin::Merchandise::Part', :dependent => :destroy

  mount_uploader :image, ImageUploader

  scope :pick, lambda{|previous_picks| where('id not in (?)', previous_picks)}

  def self.my_piece(id)
    where('id=?', id).first
  end
end
