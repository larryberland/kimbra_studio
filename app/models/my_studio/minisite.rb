class MyStudio::Minisite < ActiveRecord::Base

  attr_accessible :image, :remote_image_url, :image_cache,
                  :name, :bgcolor, :font_color, :font_family, :theme,
                  :image_width, :image_height

  belongs_to :studio, inverse_of: :minisite

  validates_presence_of :font_family

  mount_uploader :image, ImageUploader

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

  def background_dark?
    if @background_dark.nil?
      @background_dark = calc_background_brightness < 130 ? true : false
    end
    @background_dark
  end

  # http://www.nbdtech.com/Blog/archive/2008/04/27/Calculating-the-Perceived-Brightness-of-a-Color.aspx
  # value less than 130 is considered a dark background
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
      elsif (bgcolor == "black")
        @background_brightness = 1
      else
        @background_brightness = 254 # assume light background
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
      @border_color = background_dark? ? "#ffffff" : "#000000"
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