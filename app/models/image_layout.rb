class ImageLayout < ActiveRecord::Base
  attr_accessible :x, :y, :w, :h

  belongs_to :layout, :polymorphic => true

  def resize(image)
    new_image = image.resize_to_fit(w, h) if w and h
    new_image ||= image
    new_image
  end

  def rotate(image)
    new_image = image.rotate(degrees) if degrees
    new_image ||= image
    new_image
  end

  # draw the src_image onto an image defined for the offer piece
  def draw_piece(dest_image, src_image)
    # resize the item_side custom piece to fit into our Kimbra background piece
    puts "draw the item_side custom piece into the Kimbra complete piece background"
    puts "item_side custom part size:#{src_image.columns}x#{src_image.rows} onto kimbra piece at #{x} #{y} size:#{dest_image.columns}x#{dest_image.rows}"
    image = rotate(resize(src_image))
    dest_image.composite(image, x, y, Magick::SrcOverCompositeOp)
  end

  def draw_custom_part(part_image, src_image, operator=Magick::DstOverCompositeOp)
    Rails.logger.info("draw_custom_part onto #{part_image.columns}x#{part_image.rows} with viewport #{x} #{y} #{src_image.columns}x#{src_image.rows}")
    part_image.composite(src_image, x, y, operator)
  end

  private


end
