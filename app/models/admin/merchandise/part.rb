class Admin::Merchandise::Part < ActiveRecord::Base

  attr_accessible :image, :remote_image_url, :image_part, :image_part_url,
                  :piece, :portrait, :width, :height, :photo, :order,
                  :part_layout, :part_layout_attributes,
                  :piece_layout, :piece_layout_attributes,
                  :face, :face_attributes

  mount_uploader :image, ImageUploader                  # custom assembled part
  mount_uploader :image_part, ImageUploader             # kimbra part

  belongs_to :piece, :class_name => 'Admin::Merchandise::Piece'
  belongs_to :portrait, :class_name => 'MyStudio::Portrait'
  belongs_to :face, :class_name => 'MyStudio::Portrait::Face'

  has_one :item, :class_name => 'Admin::Customer::Item' # TODO: do we destroy Offer::Item on this?

  has_one :part_layout
  has_one :piece_layout
  accepts_nested_attributes_for :part_layout, :piece_layout


  def self.seed_nested_attributes(info, attr, default)
    key                               = info.key?(attr) ? attr : info.key?(attr.to_s) ? attr.to_s : attr
    info["#{attr}_attributes".to_sym] = if info.key?(key)
                                          info[key].clone
                                        else
                                          default[attr].clone
                                        end
    info.delete(key) if info.key?(key)
  end

  def self.seed(attrs, default, image_part_path)
    # convert to nested_attributes
    d = default.clone
    seed_nested_attributes(attrs, :piece_layout, d)
    seed_nested_attributes(attrs, :part_layout, d)
    seed_nested_attributes(attrs[:piece_layout_attributes], :layout, d)
    seed_nested_attributes(attrs[:part_layout_attributes], :layout, d)

    my_part = Admin::Merchandise::Part.create(attrs)
    my_part.image_part.store_file!(image_part_path.to_s)
    my_part
  end

  def generate
    f_stock, f_custom = if face.present?
                          center_on_face(face)
                        else
                          group_shot
                        end
  end

  # create a clone of merchandise_part we can use for customisation
  def self.create_clone(merchandise_part, portrait_options=nil)
    item_part          = merchandise_part.clone
    item_part.piece    = merchandise_part.piece
    item_part.save
    if portrait_options
      item_part.portrait = portrait_options[:portrait]
      item_part.face     = portrait_options[:face]
      f_stock, f_custom = if portrait_options[:face]
                            item_part.center_on_face(portrait_options[:face])
                          else
                            item_part.group_shot
                          end

    end
    item_part.copy_image(merchandise_part)
    item_part
  end

  def copy_image(from_part)
    raise "missing part image in part=>#{from_part.inspect}" if from_part.image_part.nil?
    set_from_url(image_part, from_part.image_part_url)
  end

  def draw_part(stock_image)
    part_layout.draw_custom_part(part_image, stock_image)
  end

  # draw the custom portrait image onto the Kimbra piece image
  def draw_piece(piece_image, portrait_item_image)
    puts "custom_image=>#{portrait_item_image.columns}x#{portrait_item_image.rows}"
    i = piece_layout.draw_piece(piece_image, portrait_item_image)
    puts "draw_piece=>#{piece_layout.layout.draw_piece_size.inspect}"
    i
  end

  # create a custom assembled image by resize on portrait
  def group_shot
    raise 'forget to assign portrait?' unless portrait.present?
    portrait_part_image, t_file = create_image_temp do
      portrait.resize_to_fit_and_center(part_layout.w, part_layout.h)
    end
    t_custom                    = create_custom_part(portrait_part_image)
    return t_file, t_custom
  end

  # create a custom assembled part by centering the portrait's
  #  face information onto the kimbra part
  def center_on_face(face)
    raise 'forget to assign portrait?' unless portrait.present?
    portrait_part_image, t_file = create_image_temp do
      face.center_in_area(part_layout.w, part_layout.h)
    end
    dump_cropped(portrait_part_image)
    t_custom = create_custom_part(portrait_part_image)
    return t_file, t_custom
  end

  # create a custom assembled part that does not need a photo
  def no_photo(width, height)
    no_photo_image = part_image.resize_to_fit(width, height)
    create_custom_part(no_photo_image)
    image.to_image
  end

  def to_image_span
    text = piece.to_image_span
    text = "Part #{id}" if text.blank?
    text
  end

  def item_x
    part_layout.x
  end

  def item_y
    part_layout.y
  end

  def item_width
    part_layout.w
  end

  def item_height
    part_layout.h
  end

  private

  def part_image
    raise "no image_part in #{self.inspect}" if image_part.nil?
    image_part.to_image
  end

  # using the src_image place it onto the
  #  kimbra part
  def create_custom_part(src_image)
    raise "no src_image to make custom part #{self.inspect}" if src_image.nil?
    @custom_part = part_layout.draw_custom_part(part_image, src_image)
    dump_assembled(@custom_part)
    image.store_image!(@custom_part)
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
