class MyStudio::Minisite < ActiveRecord::Base

  attr_accessible :image, :remote_image_url, :image_cache,
                  :bgcolor, :font_color, :font_family, :theme

  belongs_to :studio

  validates_presence_of :bgcolor, :font_color, :font_family

  mount_uploader :image, ImageUploader

end