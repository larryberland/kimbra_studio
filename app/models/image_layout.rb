class ImageLayout < ActiveRecord::Base
  attr_accessible :x, :y, :w, :h, :degrees

  belongs_to :layout, :polymorphic => true

  def resize(image)
    # puts "imageLayout resize:#{image.columns}x#{image.rows} to:#{w}x#{h}"
    new_image = image.resize_to_fit(w, h) if w and h
    new_image ||= image
    new_image
  end

  def rotate(image)
    if degrees
      puts "rotating #{degrees}"
      # set background transparent
      image.background_color = "transparent"
      new_image = image.rotate(degrees)

      dh = new_image.columns - image.columns
      dw = new_image.rows - image.rows

      dh = Math::sin(degrees) * new_image.columns
      puts "img #{image.columns}x#{image.rows}"
      puts "rot #{new_image.columns}x#{new_image.rows}"
      puts " dh #{dw}x#{dh}"

      rad = degrees * Math::PI / 180.0
      dh2 = Math.sin(rad) * image.columns
      puts "dh2:#{dh2}"
      if (degrees < 0)
      @new_y += dh2
      else
      @new_x -= dh2
      end


      #if (degrees < 0)
      #  @new_y -= dh
      #  @new_x -= dw
      #else
      #  @new_y += dh
      #end
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

  def draw_custom_part2(part_image, src_image, operator=Magick::DstOverCompositeOp)
    # Rails.logger.info("draw_custom_part onto #{part_image.columns}x#{part_image.rows} with viewport #{x} #{y} src_image:#{src_image.columns}x#{src_image.rows}")
    @new_x = x
    @new_y = y
    image = rotate(resize(src_image))
    part_image.composite(image, @new_x, @new_y, operator)
  end

  private


end
