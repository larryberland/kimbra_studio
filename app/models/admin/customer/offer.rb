class Admin::Customer::Offer < ActiveRecord::Base

  attr_accessible :image, :remote_image_url, :name, :email, :portrait, :piece, :description
  mount_uploader :image, ImageUploader                          # the final custom kimbra piece

  belongs_to :piece, :class_name => 'Admin::Merchandise::Piece' # kimbra piece
  belongs_to :portrait, :class_name => 'MyStudio::Portrait'     # Studio session Portrait
  belongs_to :email, :class_name => 'Admin::Customer::Email'

  has_many :items, :class_name => 'Admin::Customer::Item'       # Items that make up the custom piece

  before_save :piece_default

  def self.generate(email, portrait, piece)

    offer = Admin::Customer::Offer.create(:email    => email,
                                                      :portrait => portrait,
                                                      :piece    => piece)
    offer.assemble(piece)

    # TODO: this image should be a composite
                                        #       of all the parts of this piece put together
    file = piece.image.present? ? piece.image.file.file : Rails.root.join('app', 'assets', 'images', 'home.png')
    offer.image.store!(File.open(file)) # copy the existing for now
                                        # TODO: end

    offer.save
    offer
  end

  # assemble all the parts for this piece
  def assemble(merchandise_piece)
    raise "did you forget to assign a piece for this offer?" if merchandise_piece.nil?
    raise "did you forget to assign a studio session for this portrait?" if portrait.my_studio_session.nil?
    portraits = portrait.my_studio_session.portraits
    merchandise_piece.parts.each_with_index do |part, index|
      if portraits[index]
        self.items << Admin::Customer::Item.assemble(self, portraits[index], part)
      else
        puts "WARN: only #{portraits.size} need #{index+1}"
      end
    end
    self
  end

  # span text for Offer
  def to_image_span
    text = name.to_s
    text = piece.to_image_span if piece.present?
    text = 'Offer' if text.blank?
    text
  end

  private

  def piece_default
    if piece
      self.description = piece.short_description if description.nil?
      self.name = piece.to_offer_name if name.nil?
    end
  end

end
