class Admin::Customer::ItemSide < ActiveRecord::Base

  mount_uploader :image_stock, StockUploader                  # original portrait cropped for image part
  mount_uploader :image_custom, PartCustomUploader            # final image with portrait and part

  belongs_to :item, :class_name => 'Admin::Customer::Item'
  belongs_to :part, :class_name => 'Admin::Merchandise::Part' # my own copy of merchandise part

  belongs_to :portrait, :class_name => 'MyStudio::Portrait'
  belongs_to :face, :class_name => 'MyStudio::Portrait::Face'

  attr_accessible :image_stock, :remote_image_stock_url, :image_stock_cache,
                  :image_custom, :remote_image_custom_url, :image_custom_cache,
                  :changed_layout_at,
                  :portrait, :portrait_attributes, :portrait_id,
                  :face, :face_attributes,
                  :item, :item_attributes,
                  :part, :part_attributes,
                  :crop_x, :crop_y, :crop_h, :crop_w

  accepts_nested_attributes_for :item, :part, :portrait

  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h, :assembly

  #after_update :reposition

  after_update :crop_stock_image, if: :cropping?

  # assemble a part side for this item and portrait
  # options => {:photo_part,
  #             :portrait,
  #             :face}
  def self.assemble(item, options)
    raise "needs to be a hash options=>#{options.inspect}" unless options.kind_of?(Hash)
    my_part      = Admin::Merchandise::Part.create_clone(options[:photo_part])
    my_item_side = Admin::Customer::ItemSide.create(:item     => item,
                                                    :part     => my_part,
                                                    :portrait => options[:portrait],
                                                    :face     => options[:face])
    my_item_side.create_side
    my_item_side
  end

  def assembly?
    @assembly
  end
  # create the image_stock from [portrait | face | part]
  # create the image_custom from stock and merchandise_part
  def create_side
    @assembly = true
    if face or portrait
      self.image_stock = portrait.face_file
    else
      self.image_stock.store_file!(part.image_part.current_path)
    end
    assemble_new_side
  end

  def assemble_new_side
    # TODO: still need to figure out the difference between storage stuff
    #self.remote_image_custom_url = part.image_part.url.to_s
    self.image_custom.store_file!(part.image_part.current_path)
    save
  end

  # draw the custom portrait image onto the Kimbra piece image
  def draw_piece_with_custom(piece_image)
    dump_custom(piece_image)
    part.draw_piece(piece_image, custom_image)
  end

  # draw the image using current part information
  def draw_piece(piece_image)
    part.draw_piece(piece_image, stock_image)
  end

  # carrier_wave callback to process the current image
  #  for whatever processing we need to do
  def image_stock_process(src_image)

    puts "CW ItemSide image_stock createImage"
    if cropping?
      puts "src_img size:#{src_image.columns}x#{src_image.rows}"

      puts "crop #{crop_x} #{crop_y} #{crop_w}x#{crop_h}"
      img = src_image.crop(crop_x.to_i, crop_y.to_i, crop_w.to_i, crop_h.to_i)
      clear_cropping
      puts "img size:#{img.columns}x#{img.rows}"
      puts "  resize to #{part_layout.w}x#{part_layout.h}"
      img.resize!(part_layout.w, part_layout.h)
    elsif assembly?
      puts "  for NON cropping"
      w = part_layout.w
      h = part_layout.h
      if face
        draw_face(src_image, w, h)
      elsif portrait
        src_image.resize_to_fit(w, h)
      else
        part.no_photo(w, h)
      end
    else
      src_image # no op
    end
  end

  # carrier_wave process callback from PartCustomUploader
  def image_custom_process(part_image)
    puts "running image_custom_process place stock_image onto part."
    i = stock_image
    dump_cropped(i)
    dump_cropped(part_image)
    part_image.composite(stock_image, part_layout.x, part_layout.y, Magick::DstOverCompositeOp)
    #part_image.composite(stock_image, part_layout.x, part_layout.y, Magick::AtopCompositeOp)
  end

  def to_image_span
    text = part.to_image_span
    text = "Item #{id}" if text.blank?
    text
  end

  def image_title(attr)
    img = attr.to_image
    "size #{img.columns} x #{img.rows}"
  end

  # clear the cropping data so new recreate_versions will not crop
  def clear_cropping
    self.crop_x = nil
    self.crop_y = nil
    self.crop_w = nil
    self.crop_h = nil
  end

  def cropping?
    res = !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
    puts "cropping=>#{res}"
    res
  end

  private

  def crop_stock_image
    puts ""
    puts "#{self} after_update BEG Recreate Versions"
    image_stock.recreate_versions!
    puts "#{self} image_stock cropped=>#{image_stock.path}"
    # reset out custom image to the original kimbra part
    #  this will cause our image_custom_process callback
    #  which will slap the image_stock into its proper place
    self.image_custom.store_file!(part.image_part.path)
    true
  end

  # used in CarrierWave process center_in_area
  def get_dest_area
    return part_layout.w, part_layout.h
  end

  def draw_face(portrait_image, w, h)
    info = face.calculate_center_in_area(w, h)

    crop    = info[:crop]
    cropped = portrait_image.crop(crop[:x], crop[:y], crop[:w], crop[:h])

    resize = info[:resize]
    cropped = cropped.resize_to_fit(resize[:w], resize[:h]) if resize

    # return the cropped image into our destination image
    img = image_new(w, h)
    img.composite(cropped, 0, 0, Magick::AtopCompositeOp)
  end

  def draw_no_photo(width, height)
    part.no_photo(width, height)
  end

  def piece_layout
    part.piece_layout.layout
  end

  def part_layout
    part.part_layout.layout
  end

  # reversed name means image instead of file
  def custom_image
    image_custom.to_image
  end

  # custom portrait image for this item
  def stock_image
    puts "grabbing stock_image"
    image_stock.to_image
  end

  # return the blank part_image for this part
  def part_image
    raise "did you forget to assign a part? #{self.inspect}" if part.nil?
    part.send(:part_image)
  end

  def dump_filename
    "item_side_#{id}_piece_#{item.piece.id}_item_#{item.id}_portrait_#{portrait.id}.jpg"
  end

  def dump_cropped(img)
    dump('cropped', img)
  end

  def dump_custom(img)
    dump('custom', img)
  end

  def reposition
    if part.piece_layout.size?
      puts "#{self} #{id} piece size changed"
      #on_layout_change
    elsif part.piece_layout.position?
      puts "#{self} #{id} piece position changed"
      #@item.reposition_image
    end

    if part.part_layout.size?
      puts "#{self} #{id} part size changed"

      #@item.resize_image
      #@item.reposition_image
    elsif part.part_layout.position?
      puts "#{self} #{id} part position changed"
      #@item.reposition_image
    end
    true
  end

end