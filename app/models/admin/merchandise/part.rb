class Admin::Merchandise::Part < ActiveRecord::Base

  attr_accessible :image, :remote_image_url, :image_part, :image_part_url,
                  :piece, :portrait, :width, :height,
                  :item_x, :item_y, :item_width, :item_height
  mount_uploader :image, ImageUploader                  # custom assembled part
  mount_uploader :image_part, ImageUploader             # kimbra part

  belongs_to :piece, :class_name => 'Admin::Merchandise::Piece'
  belongs_to :portrait, :class_name => 'MyStudio::Portrait'

  has_one :item, :class_name => 'Admin::Customer::Item' # TODO: do we destroy Offer::Item on this?

  # create a replica of the merchandise_part
  #  with the current portrait.
  def self.assemble(merchandise_part, portrait)
    item_part = merchandise_part.clone
    item_part.update_attributes(:piece => merchandise_part.piece, :portrait => portrait)
    item_part.image_part.store!(merchandise_part.image_part_url)
    item_part.write_image_part_identifier
    item_part
  end

  # create a custom assembled image by resize on portrait
  def group_shot
    puts "group_shot portrait=>#{portrait.id}"
    raise 'forget to assign portrait?' unless portrait.present?
    t_resize = Tempfile.new(['resize', '.jpeg'])
    img      = Magick::Image.read(portrait.image_url).first
    resize   = img.resize_to_fit(item_width, item_height)
    resize.write(t_resize.path)
    t_assembled = save_custom_image(resize)
    return t_resize, t_assembled
  end

  # create a custom assembled part by centering the portrait's
  #  face information onto the kimbra part
  def center_on_face(face)
    raise 'forget to assign portrait?' unless portrait.present?
    dx    = (item_width - face.face_width) * 0.50
    dy    = (item_height - face.face_height) * 0.50
    new_x = [face.face_top_left_x - dx.to_i, 0].max
    new_y = [face.face_top_left_y - dy.to_i, 0].max

    puts "crop #{new_x} #{new_y} #{item_width}x#{item_height}"
    img     = Magick::Image.read(portrait.image_url(:face)).first
    cropped = img.crop(new_x, new_y, item_width, item_height) #img.crop(x, y, width, height) -> image
    t_crop  = Tempfile.new(['crop', '.jpeg'])
    cropped.write(t_crop.path)
    t_assembled = save_custom_image(cropped)
    return t_crop, t_assembled
  end

  def to_image_span
    text = piece.to_image_span
    text = "Part #{id}" if text.blank?
    text
  end

  private

  # using the src_image place it onto the
  #  kimbra part
  def save_custom_image(src_image)
    raise "no src_image to make custom part #{self.inspect}" if src_image.nil?
    raise "no image_part in #{self.inspect}" if image_part.nil?
    t_assembled = Tempfile.new(['assembled', '.jpeg'])
    image_piece = Magick::Image.read(image_part_url).first
    image_piece.composite(src_image, item_x, item_y, Magick::AtopCompositeOp).write(t_assembled.path)
    image.store!(File.open(t_assembled.path))
    write_image_identifier
    t_assembled
  end

end
