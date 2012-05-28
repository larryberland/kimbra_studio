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
    puts "#{self} my_part=>#{my_item_side.part.inspect}"
    puts "#{self} my_part=>#{my_item_side.part.part_layout.layout.inspect}"
    puts "#{self} my_part=>#{my_item_side.part.piece_layout.layout.inspect}"
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

  # store the kimbra background image into our item_side custom_image
  def assemble_new_side
    # TODO: still need to figure out the difference between storage stuff
    #self.remote_image_custom_url = part.image_part.url.to_s
    self.image_custom.store_file!(part.image_part.current_path)
    save
  end

  # carrier_wave callback to process the stock_image
  #  for whatever processing we need to do
  def image_stock_process(src_image)
    puts ""
    puts "ItemSide create image_stock"
    size = part.viewport_size
    puts "src_img size:#{src_image.columns}x#{src_image.rows} viewport size=>#{size[:w]}x#{size[:h]}"

    new_stock_image = if cropping?
                        puts "crop #{crop_x} #{crop_y} #{crop_w}x#{crop_h}"
                        img = src_image.crop(crop_x.to_i, crop_y.to_i, crop_w.to_i, crop_h.to_i)
                        clear_cropping
                        puts "img size:#{img.columns}x#{img.rows}"
                        puts "  resize to #{size[:w]}x#{size[:h]}"
                        img.resize!(size[:w], size[:h])
                      elsif assembly?
                        puts "  Assembly"
                        img = if face
                                puts "  using Face"
                                draw_face(src_image, size[:w], size[:h])
                              elsif portrait
                                puts "  using Full Portrait"
                                src_image.resize_to_fit(size[:w], size[:h])
                              else
                                puts "  using No photo"
                                image_transparent(size[:w], size[:h])
                              end
                        puts " item_side stock_image=>#{img.columns}x#{img.rows}"
                        img
                      else
                        puts "  NO OP"
                        src_image # no op
                        # need to create a transparent image here somehow
                        image_transparent(size[:w], size[:h])
                      end
    puts "item_side=>#{id} image_stock new image size #{new_stock_image.columns}x#{new_stock_image.rows}"
    new_stock_image
  end

  # carrier_wave process callback from PartCustomUploader
  def image_custom_process(part_image)
    viewport = part.viewport
    if (viewport[:w] != stock_image.columns) and (viewport[:h] != stock_image.rows)
      puts "#{self} stock_image onto part #{part_image.columns}x#{part_image.rows} viewport #{viewport[:x]} #{viewport[:y]} #{stock_image.columns}x#{stock_image.rows}"
      puts "#{self} viewport=>#{viewport.inspect}"
      raise "something up here "
    end
    puts "storing stock_image ontop of the kimbra part background using the Kimbra part viewport"
    puts "#{self} stock_image onto part #{part_image.columns}x#{part_image.rows} viewport #{viewport[:x]} #{viewport[:y]} #{stock_image.columns}x#{stock_image.rows}"
    operator = Magick::SrcOverCompositeOp
    #operator = Magick::DstOverCompositeOp
    img = part_image.composite(stock_image, viewport[:x], viewport[:y], operator)
    puts "#{self} custom_image #{img.columns}x#{img.rows}"
    #part_image.composite(stock_image, part_layout.x, part_layout.y, Magick::AtopCompositeOp)
    img
  end

  def to_image_span
    text = part.to_image_span
    text = "Item #{id}" if text.blank?
    text
  end

  # draw our custom image onto the kimbra piece image
  def draw_piece_with_custom(piece_image)
    img = part.draw_piece(piece_image, custom_image)
    dump('draw_piece_with_custom', img)
    img
  end

  # draw the image using current part information
  def draw_piece(piece_image)
    img = part.draw_piece(piece_image, stock_image)
    dump('draw_piece', img)
    img
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
    raiss "should never be here"
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
    raise "not set layout yet" if part.part_layout.nil?
    size = part.viewport_size
    raise "no viewport set" if size[:w] < 1 or size[:h] < 1
    return size[:w], size[:h]
  end

  def draw_face(portrait_image, viewport_w, viewport_h)
    info = face.calculate_center_in_area(viewport_w, viewport_h)

    crop    = info[:crop]
    cropped = portrait_image.crop(crop[:x], crop[:y], crop[:w], crop[:h])

    resize = info[:resize]
    cropped = cropped.resize_to_fit(resize[:w], resize[:h]) if resize

    # return the cropped image into our destination image
    img = image_new(viewport_w, viewport_h)
    img.composite(cropped, 0, 0, Magick::AtopCompositeOp)
  end

  def draw_no_photo(width, height)
    part.no_photo(width, height)
  end

  #def piece_layout
  #  part.piece_layout.layout
  #end
  #
  #def part_layout
  #  part.part_layout.layout
  #end

  # reversed name means image instead of file
  def custom_image
    image_custom.to_image
  end

  # custom portrait image for this item
  def stock_image
    image_stock.to_image
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

end