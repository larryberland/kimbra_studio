class Admin::Customer::Item < ActiveRecord::Base

  attr_accessible :image_stock, :image_item, :offer, :part
  mount_uploader :image_stock, AssembleUploader               # original portrait scaled for part
  mount_uploader :image_item, AssembleUploader                # final image with portrait and part

  belongs_to :offer, :class_name => 'Admin::Customer::Offer'  # offer contained in email
  belongs_to :part, :class_name => 'Admin::Merchandise::Part' # one of many parts that make up a Piece

  # Create the item for this offer
  def self.assemble(offer, portrait, merchandise_part)
    item              = Admin::Customer::Item.create(:offer => offer, :part => merchandise_part)
    resize, assembled = merchandise_part.assemble(portrait)
    item.image_stock.store!(File.open(resize.path)) if resize.present?
    item.image_item.store!(File.open(assembled.path)) if assembled.present?
    item.save
    item
  end
end
