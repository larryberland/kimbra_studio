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

  def scale_image(img)

    w          = img.columns
    h          = img.rows
    new_width  = w
    new_height = (image_width.to_f * w.to_f) / image_width.to_f
    if new_height < h
      new_width = (image_height.to_f * new_height) / image_width.to_f
    end

    # center inside new width and height
    if new_width > w
      new_x = new_x - ((new_width - w) / 2)
    elsif new_width < w
      new_x = new_x + ((w - new_width) / 2)
    end
    if new_height > h
      new_y = new_y - ((new_height - h) / 2)
    elsif new_height < h
      new_y = new_y + ((h - new_height) / 2)
    end
    {:x => new_x, :y => new_y, :width => new_width, :height => new_height}
  end

  # create a custom assembled image by resize on portrait
  def group_shot
    puts "group_shot portrait=>#{portrait.id}"
    raise 'forget to assign portrait?' unless portrait.present?
    t_resize = Tempfile.new(['resize', '.jpeg'])
    resize   = portrait.resize_to_fit_and_center(item_width, item_height)
    resize.write(t_resize.path)
    t_assembled = save_custom_image(t_resize)
    return t_resize, t_assembled
  end

  # create a custom assembled part by centering the portrait's
  #  face information onto the kimbra part
  def center_on_face(face)
    raise 'forget to assign portrait?' unless portrait.present?
    centered = face.center_in_area(item_width, item_height)
    dump_cropped(centered)
    t_crop = Tempfile.new(['crop', '.jpeg'])
    centered.write(t_crop.path)
    t_assembled = save_custom_image(t_crop)
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
  def save_custom_image(src)
    raise "no src_image to make custom part #{self.inspect}" if src.nil?
    raise "no image_part in #{self.inspect}" if image_part.nil?
    t_assembled = Tempfile.new(['assembled', '.jpeg'])
    image_piece = Magick::Image.read(image_part_url).first
    src_image   = Magick::Image.read(File.open(src.path)).first
    assemble    = image_piece.composite(src_image, item_x, item_y, Magick::AtopCompositeOp)
    assemble.write(t_assembled.path)
    dump_assembled(assemble)
    image.store!(File.open(t_assembled.path))
    write_image_identifier
    save
    t_assembled
  end

  #noinspection RubyArgCount
  def path(dir)
    p = Rails.root.join('public', 'pieces', 'parts', dir)
    p.mkpath unless File.exists?(p.to_s)
    p
  end

  def dump(dir, img, filename=nil)
    if Rails.env.development? and img
      filename ||= "part_#{id}_piece_#{piece.id}_portrait_#{portrait.id}.jpg"
      img.write(path(dir).join(filename).to_s)
    end
  end

  def dump_cropped(img)
    dump('cropped', img)
  end

  def dump_assembled(img)
    dump('assembled', img)
  end

end
