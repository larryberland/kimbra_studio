class Admin::Merchandise::Part < ActiveRecord::Base

  attr_accessible :image, :remote_image_url, :image_part, :image_part_url,
                  :piece, :portrait, :width, :height,
                  :item_x, :item_y, :item_width, :item_height,
                  :layout_part, :layout_piece
  mount_uploader :image, ImageUploader                  # custom assembled part
  mount_uploader :image_part, ImageUploader             # kimbra part

  belongs_to :piece, :class_name => 'Admin::Merchandise::Piece'
  belongs_to :portrait, :class_name => 'MyStudio::Portrait'

  has_one :item, :class_name => 'Admin::Customer::Item' # TODO: do we destroy Offer::Item on this?

  has_one :layout_part, :class_name => 'ImageLayout', :as => :layout
  has_one :layout_piece, :class_name => 'ImageLayout', :as => :layout

  # create a replica of the merchandise_part
  #  with the current portrait.
  def self.assemble(merchandise_part, portrait)
    item_part = merchandise_part.clone
    item_part.update_attributes(:piece    => merchandise_part.piece,
                                :portrait => portrait)
    item_part.copy_image(merchandise_part)
    raise "missing layout_piece in merchandise_part=>#{merchandise_part.inspect}" if item_part.layout_piece.nil?
    raise "missing layout_part in merchandise_part=>#{merchandise_part.inspect}" if item_part.layout_part.nil?
    item_part
  end

  def copy_image(from_part)
    raise "missing part image in part=>#{from_part.inspect}" if from_part.image_part.nil?
    set_from_url(image_part, from_part.image_part_url)
  end

  # draw the custom portrait image onto the Kimbra piece image
  def draw_piece(piece_image, portrait_item_image)
    layout_piece.draw_piece(piece_image, portrait_item_image)
  end

  # create a custom assembled image by resize on portrait
  def group_shot
    raise 'forget to assign portrait?' unless portrait.present?
    portrait_part_image, t_file = create_image_temp do
      portrait.resize_to_fit_and_center(layout_part.w, layout_part.h)
    end
    t_custom                    = create_custom_part(portrait_part_image)
    return t_file, t_custom
  end

  # create a custom assembled part by centering the portrait's
  #  face information onto the kimbra part
  def center_on_face(face)
    raise 'forget to assign portrait?' unless portrait.present?
    portrait_part_image, t_file = create_image_temp do
      face.center_in_area(layout_part.w, layout_part.h)
    end
    dump_cropped(portrait_part_image)
    t_custom = create_custom_part(portrait_part_image)
    return t_file, t_custom
  end

  def to_image_span
    text = piece.to_image_span
    text = "Part #{id}" if text.blank?
    text
  end

  private

  def part_image
    raise "no image_part in #{self.inspect}" if image_part.nil?
    Magick::Image.read(image_part_url).first
  end

  # using the src_image place it onto the
  #  kimbra part
  def create_custom_part(src_image)
    raise "no src_image to make custom part #{self.inspect}" if src_image.nil?
    custom_part = layout_part.draw_custom_part(part_image, src_image)
    dump_assembled(custom_part)
    save_image!(custom_part, image)
  end

  def dump_filename
    "part_#{id}_piece_#{piece.id}_portrait_#{portrait.id}.jpg"
  end

  def dump_cropped(img)
    dump('cropped', img)
  end

  def dump_assembled(img)
    dump('assembled', img)
  end

end
