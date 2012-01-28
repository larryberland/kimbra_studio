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

  def draw_piece(dest_image, src_image)
    puts inspect
    dest_image.composite(rotate(resize(src_image)), x, y, Magick::SrcOverCompositeOp)
  end

  def draw_custom_part(part_image, src_image, operator=Magick::DstOverCompositeOp)
    part_image.composite(src_image, x, y, operator)
  end

end
