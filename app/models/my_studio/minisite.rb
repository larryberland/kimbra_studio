class MyStudio::Minisite < ActiveRecord::Base

  attr_accessible :image, :remote_image_url, :image_cache,
                  :bgcolor, :font_color, :font_family, :theme,
                  :image_width, :image_height

  belongs_to :studio, inverse_of: :minisite

  validates_presence_of :font_family

  mount_uploader :image, ImageUploader

  validates :bgcolor, :presence => true,
            :format => {:with => CustomValidators::Colors.css_color_validator}

  validates :font_color, :presence => true,
              :format => {:with => CustomValidators::Colors.css_color_validator}

  FONTS = %w(Georgia Times Palatino Arial Cursive Helvetica Verdana Courier Monaco)

  before_save :check_logo_size

  def body_padding
    image_height.to_i + 40
  end

  private

  def check_logo_size
    if (image_width.nil? or image_height.nil?)
      if (image)
        if img = image.to_image
          self.image_width = img.columns
          self.image_height = img.rows
        end
      end
    end
  end
end