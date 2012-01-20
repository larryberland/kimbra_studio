class Admin::Merchandise::Part < ActiveRecord::Base
  attr_accessible :image, :remote_image_url, :image_part, :image_part_url, :piece, :portrait, :width, :height
  belongs_to :piece, :class_name => 'Admin::Merchandise::Piece'
  belongs_to :portrait, :class_name => 'MyStudio::Portrait'
  mount_uploader :image, ImageUploader
  mount_uploader :image_part, ImageUploader

  # assemble this portrait using the part information
  def assemble(portrait)

    t_resize = Tempfile.new(['resize','.jpeg'])
    img = Magick::Image.read(portrait.image.file.file).first
    resize = img.resize_to_fit(item_width, item_height)
    resize.write(t_resize.path)

    # combine the part image with the re-sized stock image
    if image_part.present?
      t_assembled = Tempfile.new(['assembled','.jpeg'])
      image_piece = Magick::Image.read(image_part.file.file).first
      image_piece.composite(resize, item_x, item_y, Magick::AtopCompositeOp).write(t_assembled.path)
    end

    return t_resize, t_assembled
  end
end
