class ImageLayout < ActiveRecord::Base
  belongs_to :layout, polymorphic: true

  attr_accessible :x, :y, :w, :h, :degrees

  after_create :set_default

  def aspect_ratio
    @aspect_ratio = w.to_f / h.to_f if @aspect_ratio.nil?
    @aspect_ratio
  end

  # true if layout is in landscape
  def landscape?
    w < h ? true : false
  end

  def resize(image)
    #puts "imageLayout resize:#{image.columns}x#{image.rows} to:#{w}x#{h}"
    new_image = image.resize_to_fit(w, h) if w and h
    new_image ||= image
    new_image
  end

  def rotate(image)
    if degrees and ((degrees < 1.0) or (degrees > 1.0))
      # set background transparent
      image.background_color = "transparent"
      new_image              = image.rotate(degrees)

      rad = degrees * Math::PI / 180.0
      dh  = Math.sin(rad) * image.columns
      #puts "degrees:#{degrees} dh:#{dh}"
      if (degrees > 90)
        # not sure what to do here
        if (degrees > 180)
          @new_x += dh
        else
          @new_y -= dh
        end
      else
        if (degrees < 0)
          @new_y += dh
        else
          @new_x -= dh
        end
      end
    end
    new_image ||= image
    new_image
  end

  # draw the src_image onto an image defined for the offer piece
  def draw_piece(dest_image, src_image)
    # puts "draw the item_side custom piece into the Kimbra complete piece background"
    # puts "item_side src_image:#{src_image.columns}x#{src_image.rows} onto dest_image piece at #{x} #{y} size:#{dest_image.columns}x#{dest_image.rows}"

    # resize the item_side custom piece to fit into our Kimbra background piece
    image = rotate(resize(src_image))
    dest_image.composite(image, x, y, Magick::SrcOverCompositeOp)
  end

  def draw_custom_part(part_image, src_image, operator=Magick::DstOverCompositeOp)
    # Rails.logger.info("draw_custom_part onto #{part_image.columns}x#{part_image.rows} with viewport #{x} #{y} src_image:#{src_image.columns}x#{src_image.rows}")
    part_image.composite(src_image, x, y, operator)
  end

  # use DstOutCompositeOp to see the exact rectangle
  # use SrcOverCompositeOp to see the photo image on top of background
  #=Magick::DstOverCompositeOp
  def draw_custom_part2(part_image, src_image, operator)
    #puts "\n draw_custom() portrait src_image #{src_image.columns}x#{src_image.rows}"
    #operator = Magick::DstOutCompositeOp
    @new_x = x
    @new_y = y
    image  = rotate(resize(src_image))
    #puts " draw_custom() at x:#{@new_x} y:#{@new_y} resized image #{image.columns}x#{image.rows}"
    part_image.composite(image, @new_x, @new_y, operator)
  end

  private

  def set_default
    self.x = 10 if x.nil?
    self.y = 10 if y.nil?
    self.w = 100 if w.nil?
    self.h = 100 if h.nil?
    save
  end

end
