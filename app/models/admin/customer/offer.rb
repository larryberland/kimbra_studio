class Admin::Customer::Offer < ActiveRecord::Base
  attr_accessible :image, :remote_image_url, :email, :portrait, :piece
  mount_uploader :image, ImageUploader
  belongs_to :piece, :class_name => 'Admin::Merchandise::Piece'
  belongs_to :portrait, :class_name => 'MyStudio::Portrait'
  belongs_to :email, :class_name => 'Admin::Customer::Email'
  has_many :items, :class_name => 'Admin::Customer::Item'

  def self.generate(email, portrait, piece)
    offer = Admin::Customer::Offer.create(:email => email, :portrait => portrait, :piece => piece)

    # TODO: overriding default behavior since not all pieces have part images
    offer.piece = Admin::Merchandise::Piece.find_by_name('Alexis Bracelet') # use for all right now
    # TODO: end

    # TODO: this image should be a composite
    #       of all the parts of this piece put together
    file = piece.image.present? ? piece.image.file.file : Rails.root.join('app','assets','images','home.png')
    offer.image.store!(File.open(file)) # copy the existing for now
    # TODO: end

    offer.assemble
    offer.save
    offer
  end

  # assemble all the parts for this piece
  def assemble
    raise "did you forget to assign a piece for this offer?" if piece.nil?
    raise "did you forget to assign a studio session for this portrait?" if portrait.my_studio_session.nil?
    portraits = portrait.my_studio_session.portraits
    piece.parts.each_with_index do |part, index|
      if portraits[index]
        self.items << Admin::Customer::Item.assemble(self, portraits[index], part)
      else
        puts "WARN: only #{portraits.size} need #{index+1}"
      end
    end
    self
  end
end
