class Admin::Customer::Item < ActiveRecord::Base

  attr_accessible :width, :height, :photo, :order,
                  :part, :part_attributes,
                  :offer, :offer_attributes


  belongs_to :offer, :class_name => 'Admin::Customer::Offer'  # offer contained in email
  belongs_to :part, :class_name => 'Admin::Merchandise::Part' # one of many parts that make up a Piece
  accepts_nested_attributes_for :part, :offer

  has_many :item_sides, :class_name => 'Admin::Customer::ItemSide', :dependent => :destroy

  # assemble an item and its sides
  #  options = [front_side => {:photo_part, :portrait, :face},
  #             back_side => {:photo_part, :portrait, :face}]
  #
  def self.assemble_side(offer, options)
    sides = [options] if options.kind_of?(Hash)
    sides ||= options

    item = assemble(offer, sides.first[:photo_part])

    item.item_sides = sides.collect do |item_side_options|
      Admin::Customer::ItemSide.assemble(item, item_side_options)
    end
    item.save
    item
  end

  def front
    item_sides[0]
  end

  def back
    item_sides[1]
  end

  def draw_piece_with_custom(piece_image, front_side)
    if side = get_side(front_side)
      side.draw_piece_with_custom(piece_image)
    else
      piece_image
    end
  end

  def draw_piece(piece_image, front_side)
    if side = get_side(front_side)
      side.draw_piece(piece_image)
    else
      piece_image
    end
  end

  def to_image_span
    text = part.to_image_span
    text = "Item #{id}" if text.blank?
    text
  end

  # controller method to resize existing image
  def resize_image
    if offer and offer.portrait and offer.portrait.image
      image_stock.remove!
      t_resize = Tempfile.new(['resize', '.jpg'])
      # TODO: this needs to handle the method that
      #  was used originally by this item when creating the stock image
      img      = Magick::Image.read(part.portrait.image_url).first
      @resize  = img.resize_to_fit(part.part_layout.w, part.part_layout.h)
      @resize.write(t_resize.path)
      set_from_file(image_stock, t_resize.path)
    end
  end

  def reposition_image
    if part and part.image_part.present?
      image_item.remove!
      @resize = Magick::Image.read(image_stock_url).first if @resize.nil?
      custom_part_file = part.send(:create_custom_part, @resize)
      set_from_file(image_item, custom_part_file.path)
      save
    end
  end

  private

  def get_side(front_side)
    front_side ? front : back
  end

  # create an Item with a part for building an offer
  def self.assemble(offer, merchandise_part)
    raise "missing kimbra part in offer=>#{offer.inspect}" unless merchandise_part.present?
    my_part = Admin::Merchandise::Part.create_clone(merchandise_part)
    item    = Admin::Customer::Item.create(:offer => offer,
                                           :part  => my_part)
    item
  end

  def save_versions(f_stock, f_custom)
    raise 'missing_file with stock image' unless File.exist?(f_stock.path)
    raise 'missing file with custom image' unless File.exist?(f_custom.path)
    set_from_file(image_stock, f_stock.path) if f_stock.present?
    set_from_file(image_custom, f_custom.path) if f_custom.present?
    save
  end

end
