class Admin::Merchandise::Part < ActiveRecord::Base
  attr_accessible :image, :remote_image_url, :image_part, :image_part_url, :piece, :portrait, :width, :height
  belongs_to :piece, :class_name => 'Admin::Merchandise::Piece'
  belongs_to :portrait, :class_name => 'MyStudio::Portrait'
  mount_uploader :image, ImageUploader
  mount_uploader :image_part, ImageUploader

  def assemble(portrait)

  end
end
