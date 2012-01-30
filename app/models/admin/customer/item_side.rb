class Admin::Customer::ItemSide < ActiveRecord::Base
  attr_accessible :image_stock, :remote_image_stock_url, :image_stock_cache,
                  :image_custom, :remote_image_custom_url, :image_custom_cache,
                  :portrait, :portrait_attributes,
                  :face, :face_attributes,
                  :item, :item_attributes,
                  :part, :part_attributes

  mount_uploader :image_stock, AssembleUploader               # original portrait scaled for part
  mount_uploader :image_custom, AssembleUploader              # final image with portrait and part

  belongs_to :item, :class_name => 'Admin::Customer::Item'
  belongs_to :part, :class_name => 'Admin::Merchandise::Part' # my own copy of merchandise part

  accepts_nested_attributes_for :item, :part

  belongs_to :portrait, :class_name => 'MyStudio::Portrait'
  belongs_to :face, :class_name => 'MyStudio::Portrait::Face'

  # assemble a part side for this item and portrait
  # options => {:photo_part,
  #             :portrait,
  #             :face}
  def self.assemble(item, options)
    raise "needs to be a hash options=>#{options.inspect}" unless options.kind_of?(Hash)
    my_part      = Admin::Merchandise::Part.create_clone(options[:photo_part])
    my_item_side = Admin::Customer::ItemSide.create(:item     => item,
                                                    :part     => my_part,
                                                    :portrait => options[:portrait],
                                                    :face     => options[:face])
    my_item_side.generate_custom_image
    my_item_side
  end

  def generate_custom_image
    raise "did you forget to assign a part? item_side=>#{self.inspect}" if part.nil?
    if portrait.present?
      f_stock, f_custom = if face.present?
                            center_on_face
                          else
                            center_on_group
                          end
    else
      f_stock, f_custom = part.no_photo
    end
    save_versions(f_stock, f_custom)
  end

  def draw_piece_with_custom(piece_image)
    part.draw_piece(piece_image, custom_image)
  end

  # draw the image using current part information
  def draw_piece(piece_image)
    part.draw_piece(piece_image, stock_image)
  end

  # draw the image using part_layout
  def draw_part

  end

  private

  # reversed name means image instead of file
  def custom_image
    Magick::Image.read(image_custom_url).first
  end

  # custom portrait image for this item
  def stock_image
    Magick::Image.read(image_stock_url).first
  end

  # return the blank part_image for this part
  def part_image
    raise "did you forget to assign a part? #{self.inspect}" if part.nil?
    part.send(:part_image)
  end

  # using the src_image place it onto the
  #  kimbra part
  def create_custom_part(src_image)
    raise "no src_image to make custom part #{self.inspect}" if src_image.nil?
    custom_part = part.draw_part(src_image)
    dump_custom(custom_part)
    image_custom.store_image!(custom_part)
  end

  def center_on_face
    raise 'forget to assign portrait?' unless portrait.present?
    portrait_part_image, t_stock = create_image_temp do
      face.center_in_size(part.part_layout.layout)
    end
    dump_cropped(portrait_part_image)

    t_custom = create_custom_part(portrait_part_image)
    return t_stock, t_custom
  end

  def center_on_group
    portrait_part_image, t_stock = create_image_temp do
      portrait.resize_to_fit_and_center(part.part_layout.w, part.part_layout.h)
    end

    t_custom = create_custom_part(portrait_part_image)
    return t_stock, t_custom
  end

  def save_versions(f_stock, f_custom)
    raise 'missing_file with stock image' unless File.exist?(f_stock.path)
    raise 'missing file with custom image' unless File.exist?(f_custom.path)
    image_stock.store_file!(f_stock.path) if f_stock.present?
    image_custom.store_file!(f_custom.path) if f_custom.present?
    save
  end

  def dump_filename
    "item_side_#{id}_piece_#{item.piece.id}_item_#{item.id}_portrait_#{portrait.id}.jpg"
  end

  def dump_cropped(img)
    dump('cropped', img)
  end

  def dump_custom(img)
    dump('custom', img)
  end

end
