class ImageLayout < ActiveRecord::Base
  attr_accessible :x, :y, :w, :h

  attr_accessor :draw_piece_size

  belongs_to :layout, :polymorphic => true

  before_validation :set_previous
  after_save :set_size

  def size
    @size ||= {:w => w, :h => h}
  end

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
    image = rotate(resize(src_image))
    @draw_piece_size = {:w => image.columns, :h => image.rows}
    dest_image.composite(image, x, y, Magick::SrcOverCompositeOp)
  end

  def draw_custom_part(part_image, src_image, operator=Magick::DstOverCompositeOp)
    part_image.composite(src_image, x, y, operator)
  end

  private

  def set_previous
    @previous = {:x => x, :y => y, :w => w, :h => h}
  end

  def set_size
    @size = nil
    size
  end
end
