class Admin::Customer::Offer < ActiveRecord::Base
  attr_accessible :image, :remote_image_url, :email, :portrait
  belongs_to :piece, :class_name => 'Admin::Merchandise::Piece'
  belongs_to :portrait, :class_name => 'MyStudio::Portrait'
  belongs_to :email, :class_name => 'Admin::Customer::Email'
  mount_uploader :image, ImageUploader

  def self.generate(email, portrait)
    Admin::Customer::Offer.new(:email => email, :portrait => portrait)
  end

  def pieceilize(piece)
    # TODO: create image using the portrait and piece information
    self.piece = piece
    self.image = piece.image.file # copy the existing for now
  end
end
