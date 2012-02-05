class ImageLayout < ActiveRecord::Base
  attr_accessible :x, :y, :w, :h

  attr_accessor :draw_piece_size

  belongs_to :layout, :polymorphic => true

  after_save :set_size

  before_update :before_reposition
  after_update :reposition

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
    image            = rotate(resize(src_image))
    @draw_piece_size = {:w => image.columns, :h => image.rows}
    puts "draw_piece=>#{inspect}"
    dest_image.composite(image, x, y, Magick::SrcOverCompositeOp)
  end

  def draw_custom_part(part_image, src_image, operator=Magick::DstOverCompositeOp)
    puts "draw_part=>#{inspect}"
    part_image.composite(src_image, x, y, operator)
  end

  def size?
    @size_changed
  end

  def position?
    @position_changed
  end

  private

  def set_size
    puts "after_save"
    @size = nil
    size
  end

  def before_reposition
    puts "before_update"
    @position_changed = (x_changed? or y_changed?) ? true : false
    @size_changed = (w_changed? or h_changed?) ? true : false
    #if size?
    #  layout.part.item_side.on_layout_change if layout.part.item_side
    #elsif position?
    #  layout.part.item_side.on_layout_change if layout.part.item_side
    #end
    puts "#{self} before_update position=>#{position?} size=>#{size?}"
    true
  end

  def reposition
    puts "after_update size=>#{size?} position=>#{position?}"
    #if size?
    #  layout.part.item_side.on_layout_change if layout.part.item_side
    #elsif position?
    #  layout.part.item_side.on_layout_change if layout.part.item_side
    #end
  end
end
