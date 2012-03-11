class MyStudio::MiniSite < ActiveRecord::Base

  attr_accessible :image, :remote_image_url, :image_cache,
                  :bgcolor, :font_color, :font_family

  belongs_to :studio

  mount_uploader :image, ImageUploader

end