class PieceLayout < ActiveRecord::Base
  attr_accessible :layout, :layout_attributes

  belongs_to :part, :class_name => 'Admin::Merchandise::Part'

  has_one :layout, :class_name => 'ImageLayout', :as => :layout
  accepts_nested_attributes_for :layout

  after_update :reposition

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
    layout.draw_piece(dest_image, src_image)
  end

  def size?
    layout.size?
  end

  def position?
    layout.position?
  end

  private

  def reposition
    if size?
      puts "#{self} #{id} size changed"
    elsif position?
      puts "#{self} #{id} position changed"
    end
  end

end