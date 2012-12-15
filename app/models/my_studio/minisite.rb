class MyStudio::Minisite < ActiveRecord::Base

  attr_accessible :image, :remote_image_url, :image_cache,
                  :name, :bgcolor, :font_color, :font_family, :theme,
                  :image_width, :image_height

  belongs_to :studio, inverse_of: :minisite

  validates_presence_of :font_family

  mount_uploader :image, ImageUploader

  validates :name, length: {maximum: 20}
  validates :bgcolor, :presence => true,
            :format             => {:with => CustomValidators::Colors.css_color_validator}

  validates :font_color, :presence => true,
            :format                => {:with => CustomValidators::Colors.css_color_validator}

  FONTS = %w(Georgia Times Palatino Arial Cursive Helvetica Verdana Courier Monaco)

  before_save :check_logo_size

  def body_padding
    image_height.to_i + 40
  end

  def font_rgb
    if (@font_rgb.nil?)
      if font_color.starts_with?('#')
        hex = bgcolor[1..-1]
        if (hex.size > 3)
          @font_rgb = hex.scan(/../).map { |color| color.to_i(16) }
        else
          @font_rgb = hex.scan(/../).map { |color| color.to_i(16) }
        end
      elsif font_color == 'black'
        @font_rgb =[0,0,0]
      elsif font_color == 'white'
        @font_rgb =[255,255,255]
      end
    end
    @font_rgb
  end

  def r
    font_rgb[0]
  end

  def g
    font_rgb[1]
  end

  def b
    font_rgb[2]
  end

  # http://www.nbdtech.com/Blog/archive/2008/04/27/Calculating-the-Perceived-Brightness-of-a-Color.aspx
  def calc_background_brightness
    if (@background_brightness.nil?)
      if bgcolor.starts_with?('#')
        hex = bgcolor[1..-1]
        if (hex.size > 3)
          rgb = hex.scan(/../).map { |color| color.to_i(16) }
        else
          rgb = hex.scan(/../).map { |color| color.to_i(16) }
        end
        @background_brightness = Math.sqrt(0.299 * (rgb[0]*rgb[0]) + 0.587 * (rgb[1]*rgb[1]) + 0.114 * (rgb[2]*rgb[2]))
      end
    end
    @background_brightness
  end

  def calc_navbar_inverse
    if (calc_background_brightness < 130)

    else

    end
  end

  def calc_border_color
    if (@border_color.nil?)
      if (calc_background_brightness < 130)
        # background is dark use white
        @border_color = "#ffffff"
      else
        # use black
        @border_color = "#000000"
      end
    end
    @border_color
  end

  private

  def check_logo_size
    if (image_width.nil? or image_height.nil?)
      if (image)
        if img = image.to_image
          self.image_width  = img.columns
          self.image_height = img.rows
        end
      end
    end
  end
end