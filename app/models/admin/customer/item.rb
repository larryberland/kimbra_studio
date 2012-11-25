class Admin::Customer::Item < ActiveRecord::Base

  belongs_to :offer, :class_name => 'Admin::Customer::Offer'  # offer contained in email
  belongs_to :part, :class_name => 'Admin::Merchandise::Part' # kimbra part this item is made from

  has_many :item_sides, :class_name => 'Admin::Customer::ItemSide', :dependent => :destroy

  attr_accessible :photo, :order,
                  :part, :part_attributes,
                  :offer, :offer_attributes,
                  :item_sides, :item_sides_attributes

  accepts_nested_attributes_for :part, :offer, :item_sides

  # assemble an item and its sides
  #  always at least one side item_sides[0]
  #
  #  options = [front_side => {:photo_part, :portrait},
  #             back_side => {:photo_part, :portrait}]
  #
  # NOTE: item is really nothing more than a holder of the front & back sides
  def self.assemble_side(offer, options)
    # if this only a hash turn it into an array of 1 for the front_side
    sides = [options] if options.kind_of?(Hash)

    # otherwise the caller has set up an array for front and back
    sides ||= options

    # Create the item and its Front item_side
    item = assemble(offer, sides.first[:photo_part])

    # Create any other sides, I hope there is only 1 more for back_side
    item.item_sides = sides.collect do |item_side_options|
      Admin::Customer::ItemSide.assemble(item, item_side_options)
    end

    item.save
    item
  end

  # list of portraits used in this item's front and back sides
  def portrait_list
    item_sides.collect{|item_side| item_side.try(:portrait)} if item_sides.present?
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

  # This is currently being used but it should be
  #  draw_part => using the part_layout instead of the piece_layout
  def draw_piece(piece_image, front_side)
    if side = get_side(front_side)
      side.draw_piece(piece_image)
    else
      piece_image
    end
  end

  # taking our current front side and draw it onto
  #  our Kimbra Custom background for the entire Kimbra Piece
  def draw_kimbra_piece(piece_image, front_side)
    if side = get_side(front_side)
      side.draw_kimbra_piece(piece_image)
    else
      piece_image
    end
  end

  def to_image_span
    text = part.to_image_span
    text = "Item #{id}" if text.blank?
    text
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
    image_stock.store_file!(f_stock.path) if f_stock.present?
    image_custom.store_file!(f_custom.path) if f_custom.present?
    save
  end

end
