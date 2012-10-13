class MyStudio::Minisite < ActiveRecord::Base

  attr_accessible :image, :remote_image_url, :image_cache,
                  :bgcolor, :font_color, :font_family, :theme

  belongs_to :studio, inverse_of: :minisite

  validates_presence_of :font_family

  mount_uploader :image, ImageUploader

  validates :bgcolor, :presence => true,
            :format => {:with => CustomValidators::Colors.css_color_validator}

  validates :font_color, :presence => true,
              :format => {:with => CustomValidators::Colors.css_color_validator}

  FONTS = %w(Georgia Times Palatino Arial Cursive Helvetica Verdana Courier Monaco)

end