class Admin::Merchandise::Part < ActiveRecord::Base

  mount_uploader :image, ImageUploader                        # custom assembled part
  mount_uploader :image_part, ImageUploader                   # background Image used to generate the custom assembled part

  belongs_to :piece, class_name: 'Admin::Merchandise::Piece'
  belongs_to :portrait, class_name: 'MyStudio::Portrait'

  has_one :item, class_name: 'Admin::Customer::Item'          # TODO: do we destroy Offer::Item on this?
  has_one :item_side, class_name: 'Admin::Customer::ItemSide' # TODO: do we destroy Offer::Item on this?

  has_one :part_layout                                        # the viewport coordinates for the image_part background
  has_one :piece_layout

  attr_accessible :image, :image_cache, :remote_image_url, :image_width, :image_height,
                  :image_part, :image_part_cache, :image_part_url, :image_part_width, :image_part_height,
                  :photo, :order,
                  :piece, :portrait,
                  :part_layout, :part_layout_attributes,
                  :piece_layout, :piece_layout_attributes
  accepts_nested_attributes_for :part_layout, :piece_layout

  attr_accessor :width, :height                               # generic form of image_part_width

  after_create :create_layout_info

  def self.seed_nested_attributes(info, attr, default)
    key                               = info.key?(attr) ? attr : info.key?(attr.to_s) ? attr.to_s : attr
    info["#{attr}_attributes".to_sym] = if info.key?(key)
                                          info[key].clone
                                        else
                                          default[attr].clone
                                        end
    info.delete(key) if info.key?(key)
  end

  def self.seed(attrs, default, image_part_path)
    # convert to nested_attributes
    d = default.clone
    seed_nested_attributes(attrs, :piece_layout, d)
    seed_nested_attributes(attrs, :part_layout, d)
    seed_nested_attributes(attrs[:piece_layout_attributes], :layout, d)
    seed_nested_attributes(attrs[:part_layout_attributes], :layout, d)

    my_part = Admin::Merchandise::Part.create(attrs)
    my_part.image_part.store_file!(image_part_path.to_s)
    my_part
  end

  # clone a merchandises part for the customer's custom part
  def self.create_clone(merchandise_part)
    # clone a new copy for our customer's custom part
    item_part       = merchandise_part.clone

                   # use the same merchandise part's, piece (no clone)
    item_part.piece = merchandise_part.piece

    item_part.save # save before fog so we have valid Id for image s3 paths

    # copy the original merchandise part images into the fog
    item_part.copy_image(merchandise_part)
    item_part
  end

  def width
    self.image_part_width # width of the original kimbra background image part graphic
  end

  def height
    self.image_part_height # height of the original kimbra background image part graphic
  end

  def to_title_size
    "size: #{width}x#{height}"
  end

  # the portrait viewport dimensions onto the image_part background image
  def viewport
    viewport_offset.merge(viewport_size)
  end

  # the viewport top left corner where we place the portrait into the
  #  image_part graphic
  def viewport_offset
    @viewport_offset ||= {x: part_layout.x.to_i, y: part_layout.y.to_i}
  end

  # the viewport size where we place the portrait into the
  #  image_part graphic
  def viewport_size
    @viewport_size ||= {w: part_layout.w.to_i, h: part_layout.h.to_i}
  end

  def copy_image(from_part)
    raise "missing part image in part=>#{from_part.inspect}" if from_part.image_part.nil?
    set_from_url(image_part, from_part.image_part_url)
  end

  def draw_part(stock_image)
    part_layout.draw_custom_part(part_image, stock_image)
  end

  # draw the custom portrait image using the piece_layout viewport
  def draw_piece(piece_image, portrait_item_image)
    # puts "LDB: part::draw_piece() portrait_item_image=>#{portrait_item_image.columns}x#{portrait_item_image.rows}"
    piece_layout.draw_piece(piece_image, portrait_item_image)
  end

  # draw custom portrait image using the piece_layout viewport
  #   with Composite
  def draw_kimbra_piece(piece_image, portrait_item_image)
    # puts "LDB: part::draw_piece() portrait_item_image=>#{portrait_item_image.columns}x#{portrait_item_image.rows}"
    piece_layout.draw_kimbra_piece(piece_image, portrait_item_image)
  end

  # create a custom assembled part that does not need a photo
  def no_photo(width, height)
    no_photo_image = part_image.resize_to_fit(width, height)
    create_custom_part(no_photo_image)
    image.to_image
  end

  def to_image_span
    text = piece.to_image_span
    text = "Part #{id}" if text.blank?
    text
  end

  def cropilize

    if @cropilize.nil?

      # cropbox size based on the part's wxh into a 300 wide
      orig_width  = width.to_f
      orig_height = height.to_f
      dest_width  = 300.0
      dest_height = (dest_width * orig_height) / orig_width

      cropbox_w  = dest_width  # $('#cropbox').width()
      cropbox_h  = dest_height # $('#cropbox').height()
      @cropilize = {w: cropbox_w.round, h: cropbox_h.round}

      viewport_aspect_ratio = part_layout.aspect_ratio

      if part_layout.landscape?
        x1 = cropbox_w / 6     # one-sixth the way across
        y1 = (cropbox_h / 6) + 0.5 * (cropbox_h * 4 / 6 - cropbox_w * 4 / 6 / viewport_aspect_ratio)
        x2 = cropbox_w * 5 / 6 # five-sixths the way across
        y2 = (cropbox_h * 5 / 6) - 0.5 * (cropbox_h * 4 / 6 - cropbox_w * 4 / 6 / viewport_aspect_ratio)
      else # landscape style
        x1 = (cropbox_w / 6) + 0.5 * (cropbox_w * 4 / 6 - cropbox_h * 4 / 6 * viewport_aspect_ratio)
        y1 = cropbox_h / 6 # one-sixth the way down
        x2 = (cropbox_w * 5 / 6) - 0.5 * (cropbox_w * 4 / 6 - cropbox_h * 4 / 6 * viewport_aspect_ratio)
        y2 = cropbox_h * 5 / 6 # five-sixths the way down
      end
      @cropilize[:crop] = {x: x1.round, y: y1.round, w: (x2.round - x1.round), h: (y2.round - y1.round)}
    end
    return @cropilize
  end

  private

  def part_image
    raise "no image_part in #{self.inspect}" if image_part.nil?
    image_part.to_image
  end

  # using the src_image place it onto the
  #  kimbra part
  def create_custom_part(src_image)
    raise "no src_image to make custom part #{self.inspect}" if src_image.nil?
    @custom_part = part_layout.draw_custom_part(part_image, src_image)
    dump('assembled', @custom_part) if Rails.env.development?
    image.store_image!(@custom_part)
  end

  def dump_filename
    "part_#{id}_piece_#{piece.id}_portrait_#{portrait.id}.jpg"
  end

  # assure that we have part and piece layout info for this
  #   part of the Kimbra piece
  def create_layout_info
    self.piece_layout ||= PieceLayout.create(layout: ImageLayout.create)
    self.part_layout  ||= PartLayout.create(layout: ImageLayout.create)
    save
  end

end
