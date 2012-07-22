class Admin::Merchandise::Piece < ActiveRecord::Base
  attr_accessible :image, :remote_image_url,
                  :category, :name, :short_description, :description_markup,
                  :sku, :price, :custom_layout,
                  :active, :featured, :deleted_at

  mount_uploader :image, ImageUploader

  has_many :offers, :class_name => 'Admin::Email::Offer'
  has_many :parts, :class_name => 'Admin::Merchandise::Part', :dependent => :destroy

  scope :pick, lambda { |previous_picks| where('id not in (?)', previous_picks) }
  scope :are_active, lambda { where('active = ?', true) }
  scope :under_price, lambda { |price_value| where('price < ?', price_value) }
  scope :by_name, lambda { |name| where('name like ?', name) }


  # return a hash of all pieces to use when deciding
  #   on a strategy for sending offers to prospective clients
  def self.to_strategy
    # currently using everything except Holiday category
    #   and the admin has set Active in the database
    by_category = are_active.all.group_by { |r| r.category }
    by_category.delete('Holiday')
    by_category
  end

  def photo_parts
    parts.select { |part| part.photo? }
  end

  def non_photo_parts
    parts - photo_parts
  end

  def get_image
    image.to_image
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
