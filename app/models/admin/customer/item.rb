class Admin::Customer::Item < ActiveRecord::Base

  attr_accessible :image_stock, :remote_image_stock_url, :image_item, :remote_image_item_url,
                  :offer, :part, :width, :height, :photo, :order,
                  :image_item_cache, :part_attributes

  mount_uploader :image_stock, AssembleUploader               # original portrait scaled for part
  mount_uploader :image_item, AssembleUploader                # final image with portrait and part

  belongs_to :offer, :class_name => 'Admin::Customer::Offer'  # offer contained in email
  belongs_to :part, :class_name => 'Admin::Merchandise::Part' # one of many parts that make up a Piece
  accepts_nested_attributes_for :part


  def self.assemble_portrait(offer, merchandise_part, portrait_options)
    raise "offer=>#{offer.id} for merchandise_part=>#{merchandise_part.id} has no portrait=>#{portrait_options.inspect}" if portrait_options[:portrait].nil?
    item              = assemble(offer, merchandise_part, portrait_options[:portrait])
    f_stock, f_custom = if portrait_options[:face]
                          item.part.center_on_face(portrait_options[:face])
                        else
                          item.part.group_shot
                        end
    item.save_versions(f_stock, f_custom)
    item
  end

  def self.assemble_no_photo(offer, merchandise_part)
    item              = assemble(offer, merchandise_part, nil)
    resize, assembled = item.part.no_photo
    item.save_versions(resize, assembled)
    item
  end

  def custom_image
    Magick::Image.read(image_item_url).first
  end

  # custom portrait image for this item
  def stock_image
    Magick::Image.read(image_stock_url).first
  end

  def draw_piece_with_custom(piece_image)
    part.draw_piece(piece_image, custom_image)
  end

  def draw_piece(piece_image)
    part.draw_piece(piece_image, stock_image)
  end

  def save_versions(stock, assembled)
    raise 'could not resize image' unless File.exist?(stock.path)
    raise 'could not assemble image' unless File.exist?(assembled.path)
    set_from_file(image_stock, stock.path) if stock.present?
    set_from_file(image_item, assembled.path) if assembled.present?
    save
  end

  def to_image_span
    text = part.to_image_span
    text = "Item #{id}" if text.blank?
    text
  end

  # controller method to resize existing image
  def resize_image
    if offer and offer.portrait and offer.portrait.image
      image_stock.remove!
      t_resize = Tempfile.new(['resize', '.jpg'])
      # TODO: this needs to handle the method that
      #  was used originally by this item when creating the stock image
      img      = Magick::Image.read(part.portrait.image_url).first
      @resize  = img.resize_to_fit(part.part_layout.w, part.part_layout.h)
      @resize.write(t_resize.path)
      set_from_file(image_stock, t_resize.path)
    end
  end

  def reposition_image
    if part and part.image_part.present?
      image_item.remove!
      @resize = Magick::Image.read(image_stock_url).first if @resize.nil?
      custom_part_file = part.send(:create_custom_part, @resize)
      set_from_file(image_item, custom_part_file.path)
      save
    end
  end

  private

  # create an Item with a part for building an offer
  def self.assemble(offer, merchandise_part, portrait)
    raise "missing kimbra part in offer=>#{offer.inspect}" unless merchandise_part.present?
    item      = Admin::Customer::Item.create(:offer => offer)
    item.part = Admin::Merchandise::Part.assemble(merchandise_part, portrait) # create a replica of merchandise part for this item
    item
  end

end
