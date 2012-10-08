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

  scope :by_category, lambda { |category| where('active=? and category IN(?)', true, category) }
  scope :for_strategy, lambda { |categories| where('active=? and category IN(?)', true, categories) }
  scope :for_bracelets, lambda { by_category('Photo Bracelets') }

  scope :search, lambda {|value|
    like_exp = value.present? ? "%#{value.gsub('%', '\%').gsub('_','\_')}%" : "%"
    where( 'category ilike ? OR name ilike ?', like_exp, like_exp).order('active desc, category desc, name asc')
  }

  # determines both the number of offers we send out and from which category
  #  when the Holiday's start we can just add to this array
  # ["Photo Bracelets", "Photo Necklaces", "Holiday", "Photo Charms"] as of 10/7/2012
  def self.strategy_categories
    if Rails.env.development?
      Admin::Merchandise::Piece.select('distinct(category)').collect(&:category)
    else
      ['Photo Necklaces', 'Photo Charms']
    end
  end

  # get all kimbra merchandise pieces for this category
  # that have photo_parts AND also are marked active?
  def self.to_strategy_category(category)
    by_category(category).all.select{|r| r.photo_parts.present?}
  end

  # return a hash of all piece categories to use when deciding
  #   on a strategy when sending offers to prospective clients
  def self.to_strategy
    # we only want kimbra pieces that have the categories defined by
    #   strategy_categories Array
    #   10/7/2012 => using Photo Necklaces and Photo Charms according to thie
    # TODO:  I don't think this is the case as i see charms and bracelets right now?
    strategy_categories.collect{|category| to_strategy_category(category)}.flatten.group_by{|r| r.category}
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
