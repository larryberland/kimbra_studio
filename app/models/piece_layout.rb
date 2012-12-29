class PieceLayout < ActiveRecord::Base
  attr_accessible :operator, :layout, :layout_attributes

  belongs_to :part, :class_name => 'Admin::Merchandise::Part'

  has_one :layout, :class_name => 'ImageLayout', :as => :layout
  accepts_nested_attributes_for :layout

  def x
    layout.x
  end

  def y
    layout.y
  end

  def w
    layout.w
  end

  def h
    layout.h
  end

  def draw_piece(dest_image, src_image)
    #puts "LDB:draw_piece() #{self}=>#{layout.inspect}"
    layout.draw_piece(dest_image, src_image)
  end

  def draw_kimbra_piece(dest_image, src_image)
    #puts "LDB:draw_kimbra_piece() #{self}=>#{layout.inspect}"
    op = case operator
           when 'DstOverOverCompositeOp'
             Magick::DstOverCompositeOp
           when 'DstOutCompositeOp'
             Magick::DstOutCompositeOp
           when 'SrcOverCompositeOp'
             Magick::SrcOverCompositeOp
           else
             Magick::DstOverCompositeOp
         end
    layout.draw_custom_part2(dest_image, src_image, op)
  end

end