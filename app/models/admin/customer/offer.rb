class Admin::Customer::Offer < ActiveRecord::Base
  attr_accessible :image, :remote_image_url, :email, :portrait
  mount_uploader :image, AssembleUploader
  belongs_to :piece, :class_name => 'Admin::Merchandise::Piece'
  belongs_to :portrait, :class_name => 'MyStudio::Portrait'
  belongs_to :email, :class_name => 'Admin::Customer::Email'
  has_many :items, :class_name => 'Admin::Customer::Item'

  def self.generate(email, portrait)
    Admin::Customer::Offer.new(:email => email, :portrait => portrait)
  end

  def pieceilize(piece)
    # TODO: create image using the portrait and piece information
    self.piece = piece
    self.piece = Admin::Merchandise::Piece.find_by_name('Alexis Bracelet') # use for all right now
    self.image.store!(piece.image.file) # copy the existing for now
  end

  # assemble all the parts for this piece
  def assemble
    portraits = portrait.my_studio_session.portraits

    piece.parts.each_with_index do |part, index|
      if portraits[index]
        self.items << Admin::Customer::Item.assemble(self, portraits[index], part)
      else
        puts "WARN: only #{portraits.size} need #{index}"
      end
    end
  end
end
