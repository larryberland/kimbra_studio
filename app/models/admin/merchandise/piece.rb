class Admin::Merchandise::Piece < ActiveRecord::Base
  attr_accessible :image, :remote_image_url,
                  :name, :short_description, :long_description,
                  :sku, :price, :custom_layout,
                  :active, :featured, :deleted_at

  mount_uploader :image, ImageUploader

  has_many :offers, :class_name => 'Admin::Email::Offer'
  has_many :parts, :class_name => 'Admin::Merchandise::Part', :dependent => :destroy

  scope :pick, lambda{|previous_picks| where('id not in (?)', previous_picks)}

  def photo_parts
    @photo_parts ||= parts.select { |part| part.photo? }
  end

  def non_photo_parts
    @non_photo_parts ||= (parts - photo_parts)
  end

  def get_image
    Magick::Image.read(image_url).first
  end

  # span text for Piece
  def to_image_span
    text = name.to_s
    text = 'Piece' if text.blank?
    text
  end

  def to_offer_name
    text = name.to_s
    text = 'Piece' if text.blank?
    text
  end

end
