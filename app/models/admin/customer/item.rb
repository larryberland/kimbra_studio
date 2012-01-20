class Admin::Customer::Item < ActiveRecord::Base

  attr_accessible :image_stock, :remote_image_stock_url, :image_item, :remote_image_item_url,
                  :offer, :part,
                  :item_x, :item_y, :item_width, :item_height,
                  :width, :height

  mount_uploader :image_stock, AssembleUploader               # original portrait scaled for part
  mount_uploader :image_item, AssembleUploader                # final image with portrait and part

  belongs_to :offer, :class_name => 'Admin::Customer::Offer'  # offer contained in email
  belongs_to :part, :class_name => 'Admin::Merchandise::Part' # one of many parts that make up a Piece

  before_create :default_part
  before_save :reposition_image

  # Create the item for this offer
  def self.assemble(offer, portrait, merchandise_part)
    item              = Admin::Customer::Item.create(:offer => offer, :part => merchandise_part)
    resize, assembled = merchandise_part.assemble(portrait)
    item.image_stock.store!(File.open(resize.path)) if resize.present?
    item.image_item.store!(File.open(assembled.path)) if assembled.present?
    item.save
    item
  end

  def to_image_span
    text = part.to_image_span
    text = "Item #{id}" if text.blank?
    text
  end

  private

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

  def reposition_image
    if self.id
      if part and part.image_part.present?
        resize      = Magick::Image.read(image_stock.file.file).first
        t_assembled = Tempfile.new(['assembled', '.jpeg'])
        image_piece = Magick::Image.read(part.image_part.file.file).first
        image_piece.composite(resize, item_x, item_y, Magick::AtopCompositeOp).write(t_assembled.path)
        image_item.store!(File.open(t_assembled.path))
        image_item.cache_stored_file!
        image_item.recreate_versions!
      end
    end
  end
end
