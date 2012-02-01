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
    my_item_side.draw_part
    my_item_side
  end

  # draw the image using part_layout
  def draw_part
    image = create_stock_image(part_layout)
    create_custom_part(image)
    save
  end

  # draw the custom portrait image onto the Kimbra piece image
  def draw_piece_with_custom(piece_image)
    part.draw_piece(piece_image, custom_image)
  end

  # draw the image using current part information
  def draw_piece(piece_image)
    part.draw_piece(piece_image, stock_image)
  end

  def create_stock_image(layout)
    image = if face
              draw_face(layout.w, layout.h)
            elsif portrait
              draw_portrait(layout.w, layout.h)
            else
              draw_no_photo(layout.w, layout.h)
            end
    image_stock.store_image!(image)
    image
  end

  private

  def draw_face(width, height)
    image = face.center_in_area(width, height)
    dump_cropped(image)
    image
  end

  def draw_portrait(width, height)
    image = portrait.resize_to_fit_and_center(width, height)
    dump_cropped(image)
    image
  end

  def draw_no_photo(width, height)
    part.no_photo(width, height)
  end

  def piece_layout
    part.piece_layout.layout
  end

  def part_layout
    part.part_layout.layout
  end

  # reversed name means image instead of file
  def custom_image
    image_custom.to_image
  end

  # custom portrait image for this item
  def stock_image
    image_stock.to_image
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

  def save_versions(f_stock, f_custom)
    raise 'missing_file with stock image' unless File.exist?(f_stock.path)
    raise 'missing file with custom image' unless File.exist?(f_custom.path)
    image_stock.store_image!(f_stock.path) if f_stock.present?
    image_custom.store_image!(custom_imagef_custom.path) if f_custom.present?
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
