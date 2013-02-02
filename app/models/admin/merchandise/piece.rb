class Admin::Merchandise::Piece < ActiveRecord::Base

  has_many :parts, class_name: 'Admin::Merchandise::Part', dependent: :destroy

  attr_accessible :image, :image_cache, :remote_image_url,
                  :category, :name, :short_description, :description_markup,
                  :sku, :price, :photo, :custom_layout,
                  :active, :featured, :deleted_at,
                  :width, :height, :use_part_image

  mount_uploader :image, ImageUploader

  scope :pick, lambda { |previous_picks| where('id not in (?)', previous_picks) }
  scope :are_active, lambda { where('active = ?', true) }
  scope :under_price, lambda { |price_value| where('price < ?', price_value) }
  scope :by_name, lambda { |name| where('name like ?', name) }

  scope :by_category, lambda { |category| where('active=? and category IN(?)', true, category) }
  scope :for_strategy, lambda { |categories| where('active=? and category IN(?)', true, categories) }
  scope :for_bracelets, lambda { by_category('Photo Bracelets') }
  scope :non_photo_charms, lambda { where('photo=? AND category NOT IN(?)', false, 'Chains').order('name ASC') }
  scope :for_chains, lambda { by_category('Chains').order('name ASC') }
  scope :are_active_with_photo, lambda { where('active=? and photo=?', true, true).order("name ASC") }
  scope :for_build_a_piece, lambda {|category|
    where('active=? and photo=? and category IN(?)', true, true, category).order('name ASC')
  }

  scope :search, lambda { |value|
    if value
      like_exp = value.present? ? "%#{value.gsub('%', '\%').gsub('_', '\_')}%" : "%"
      where('category ilike ? OR name ilike ?', like_exp, like_exp).order('active desc, category desc, name asc')
    else
      order('active desc, category desc, name asc')
    end
  }

  @@inventory_size = are_active_with_photo.size

  def self.inventory_size
    @@inventory_size
  end

  def self.categories
    Admin::Merchandise::Piece.select('distinct(category)').collect(&:category) - ['Chains']
  end
  # determines both the number of offers we send out and from which category
  #  when the Holiday's start we can just add to this array
  # ["Photo Bracelets", "Photo Necklaces", "Holiday", "Photo Charms"] as of 10/7/2012
  def self.strategy_categories
    if false # Rails.env.development?
      Admin::Merchandise::Piece.select('distinct(category)').collect(&:category)
    else
      ['Photo Necklaces', 'Photo Charms']
    end
  end

  # get all kimbra merchandise pieces for this category
  # that have photo_parts AND also are marked active?
  def self.to_strategy_category(category)
    by_category(category).all.select { |r| r.photo_parts.present? }
  end

  # return a hash of all piece categories to use when deciding
  #   on a strategy when sending offers to prospective clients
  def self.to_strategy
    # we only want kimbra pieces that have the categories defined by
    #   strategy_categories Array
    #   10/7/2012 => using Photo Necklaces and Photo Charms according to thie
    # TODO:  I don't think this is the case as i see charms and bracelets right now?
    strategy_categories.collect { |category| to_strategy_category(category) }.flatten.group_by { |r| r.category }
  end

  def self.fog_buster(piece_id)
    p = find(piece_id)
    p.image.fog_buster
    p.save
    p
  end

  def photo_parts
    parts_by_order = parts.sort_by(&:order)
    parts_by_order.select { |part| part.photo? }
  end

  def non_photo_parts
    parts - photo_parts
  end

  def get_image
    if use_part_image?
      # use the background image from the part instead of the
      #   default kimbra piece
      parts.first.image_part.to_image
    else
      image.to_image
    end
  end

  def category_view
    category.to_s.gsub("Photo ", "")
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

  def to_title_size
    "size: #{width}x#{height}"
  end

end
