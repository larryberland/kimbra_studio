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

  after_update :reposition

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
    my_item_side.create_side
    my_item_side
  end

  def on_layout_change
    # redraw the item_side
    create_side
    if item.offer.present?
      item.offer.on_layout_change
    end
  end
  # create the image_stock from [portrait | face | part]
  # create the image_custom from stock and merchandise_part
  def create_side
    create_image_custom(size_image_stock(part_layout))
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

  def size_image_stock(layout)
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

  def to_image_span
    text = part.to_image_span
    text = "Item #{id}" if text.blank?
    text
  end

  def image_title(attr)
    img = attr.to_image
    "size #{img.columns} x #{img.rows}"
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
  def create_image_custom(src_image)
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

  def reposition

    if part.piece_layout.size?
      puts "#{self} #{id} piece size changed"
      #@item.resize_image
      #@item.reposition_image
    elsif part.piece_layout.position?
      puts "#{self} #{id} piece position changed"
      #@item.reposition_image
    end

    if part.part_layout.size?
      puts "#{self} #{id} part size changed"

      #@item.resize_image
      #@item.reposition_image
    elsif part.part_layout.position?
      puts "#{self} #{id} part position changed"
      #@item.reposition_image
    end

  end
end
