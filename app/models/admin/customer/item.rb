class Admin::Customer::Item < ActiveRecord::Base

  attr_accessible :image_stock, :remote_image_stock_url, :image_item, :remote_image_item_url,
                  :offer, :part,
                  :item_x, :item_y, :item_width, :item_height,
                  :width, :height, :image_item_cache

  mount_uploader :image_stock, AssembleUploader               # original portrait scaled for part
  mount_uploader :image_item, AssembleUploader                # final image with portrait and part

  belongs_to :offer, :class_name => 'Admin::Customer::Offer'  # offer contained in email
  belongs_to :part, :class_name => 'Admin::Merchandise::Part' # one of many parts that make up a Piece

  before_create :default_part

  def self.assemble_portrait_face(offer, merchandise_part, portrait, face)
    item              = assemble(offer, merchandise_part, portrait)
    resize, assembled = item.part.center_on_face(face)
    item.save_versions(resize, assembled)
    item
  end

  def self.assemble_portrait(offer, merchandise_part, portrait)
    item              = assemble(offer, merchandise_part, portrait)
    resize, assembled = item.part.group_shot
    item.save_versions(resize, assembled)
    item
  end

  def custom_image
    Magick::Image.read(image_item_url).first
  end

  def stock_image
    Magick::Image.read(image_stock_url).first
  end

  def save_versions(stock, assembled)
    raise 'could not resize image' unless File.exist?(stock.path)
    raise 'could not assemble image' unless File.exist?(assembled.path)
    if stock.present?
      image_stock.store!(File.open(stock.path))
      write_image_stock_identifier
    end
    if assembled.present?
      image_item.store!(File.open(assembled.path))
      write_image_item_identifier
    end
    puts "stock    =>#{stock.path}"
    puts "assembled=>#{assembled.path}"
    save
  end

  def to_image_span
    text = part.to_image_span
    text = "Item #{id}" if text.blank?
    text
  end

  def resize_image
    if offer and offer.portrait and offer.portrait.image
      image_stock.remove!
      t_resize = Tempfile.new(['resize', '.jpeg'])
      img      = Magick::Image.read(offer.portrait.image_url).first
      @resize  = img.resize_to_fit(item_width, item_height)
      @resize.write(t_resize.path)
      image_stock.store!(File.open(t_resize.path))
      write_image_stock_identifier
    end
  end

  def reposition_image
    if part and part.image_part.present?
      image_item.remove!
      @resize = Magick::Image.read(image_stock_url).first if @resize.nil?
      t_assembled = Tempfile.new(['assembled', '.jpeg'])
      image_piece = Magick::Image.read(part.image_part_url).first
      image_piece.composite(@resize, item_x, item_y, Magick::AtopCompositeOp).write(t_assembled.path)
      image_item.store!(File.open(t_assembled.path))
      write_image_item_identifier
      save
    end
  end

  private

  # create an Item with a part for building an offer
  def self.assemble(offer, merchandise_part, portrait)
    raise "missing kimbra part in offer=>#{offer.inspect}" unless merchandise_part.present?
    raise "missing portrait in offer=>#{offer.inspect}" unless portrait.present?
    item = Admin::Customer::Item.create(:offer => offer)
    item.part = Admin::Merchandise::Part.assemble(merchandise_part, portrait) # create a replica of merchandise part for this item
    item.send(:default_part) # load coordinates
    item
  end


  # on create grab the item position information
  #  from the Part
  def default_part
    if part
      self.item_x      = part.item_x
      self.item_y      = part.item_y
      self.item_width  = part.item_width
      self.item_height = part.item_height
    end
  end
end
