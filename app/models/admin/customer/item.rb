class Admin::Customer::Item < ActiveRecord::Base
  attr_accessible :image_stock, :image_item
  mount_uploader :image_stock, AssembleUploader # original portrait scaled for part
  mount_uploader :image_item, AssembleUploader  # final image with portrait and part
  belongs_to :offer
  belongs_to :part

  def self.assemble(offer, portrait, part)

    item = Admin::Customer::Item.create(:offer => offer)
    t = Tempfile.new(['stock','.jpeg'])
    img = Magick::Image.read(portrait.image.file.file).first
    puts "Resize=>#{part.item_width}x#{part.item_height}"
    resize = img.resize_to_fit(part.item_width, part.item_height)
    resize.write(t.path)
    item.image_stock.store!(File.open(t.path)) # re-sized portrait

    # combine the part image with the re-sized stock image
    if part.image_part.present?
      t2 = Tempfile.new(['assembled','.jpeg'])
      image_piece = Magick::Image.read(part.image_part.file.file).first
      image_piece.composite(resize, part.item_x, part.item_y, Magick::AtopCompositeOp).write(t2.path)
      item.image_item.store!(File.open(t2.path))
    end

    item.save
    item
  end
end
