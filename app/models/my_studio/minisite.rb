class MyStudio::Minisite < ActiveRecord::Base

  belongs_to :studio, inverse_of: :minisite

  attr_accessible :image, :remote_image_url, :image_cache,
                  :name, :bgcolor, :font_color, :font_family, :theme,
                  :image_width, :image_height

  validates_presence_of :font_family

  mount_uploader :image, ImageUploader

  validates :bgcolor, :presence => true,
            :format             => {:with => CustomValidators::Colors.css_color_validator}

  validates :font_color, :presence => true,
            :format                => {:with => CustomValidators::Colors.css_color_validator}

  FONTS = %w(Georgia Times Palatino Arial Cursive Helvetica Verdana Courier Monaco)

  COLORNAMES = {aliceblue:"#f0f8ff",antiquewhite:"#faebd7",aqua:"#00ffff",aquamarine:"#7fffd4",azure:"#f0ffff",
                beige:"#f5f5dc",bisque:"#ffe4c4",black:"#000000",blanchedalmond:"#ffebcd",blue:"#0000ff",blueviolet:"#8a2be2",
                brown:"#a52a2a",burlywood:"#deb887",cadetblue:"#5f9ea0",chartreuse:"#7fff00",chocolate:"#d2691e",
                coral:"#ff7f50",cornflowerblue:"#6495ed",cornsilk:"#fff8dc",crimson:"#dc143c",cyan:"#00ffff",darkblue:"#00008b",
                darkcyan:"#008b8b",darkgoldenrod:"#b8860b",darkgray:"#a9a9a9",darkgreen:"#006400",darkkhaki:"#bdb76b",
                darkmagenta:"#8b008b",darkolivegreen:"#556b2f",darkorange:"#ff8c00",darkorchid:"#9932cc",darkred:"#8b0000",
                darksalmon:"#e9967a",darkseagreen:"#8fbc8f",darkslateblue:"#483d8b",darkslategray:"#2f4f4f",darkturquoise:"#00ced1",
                darkviolet:"#9400d3",deeppink:"#ff1493",deepskyblue:"#00bfff",dimgray:"#696969",dodgerblue:"#1e90ff",
                firebrick:"#b22222",floralwhite:"#fffaf0",forestgreen:"#228b22",fuchsia:"#ff00ff",gainsboro:"#dcdcdc",
                ghostwhite:"#f8f8ff",gold:"#ffd700",goldenrod:"#daa520",gray:"#808080",green:"#008000",greenyellow:"#adff2f",
                honeydew:"#f0fff0",hotpink:"#ff69b4",indianred:"#cd5c5c",indigo:"#4b0082",ivory:"#fffff0",khaki:"#f0e68c",
                lavender:"#e6e6fa",lavenderblush:"#fff0f5",lawngreen:"#7cfc00",lemonchiffon:"#fffacd",lightblue:"#add8e6",
                lightcoral:"#f08080",lightcyan:"#e0ffff",lightgoldenrodyellow:"#fafad2",lightgrey:"#d3d3d3",lightgreen:"#90ee90",
                lightpink:"#ffb6c1",lightsalmon:"#ffa07a",lightseagreen:"#20b2aa",lightskyblue:"#87cefa",lightslategray:"#778899",
                lightsteelblue:"#b0c4de",lightyellow:"#ffffe0",lime:"#00ff00",limegreen:"#32cd32",linen:"#faf0e6",
                magenta:"#ff00ff",maroon:"#800000",mediumaquamarine:"#66cdaa",mediumblue:"#0000cd",mediumorchid:"#ba55d3",
                mediumpurple:"#9370d8",mediumseagreen:"#3cb371",mediumslateblue:"#7b68ee",mediumspringgreen:"#00fa9a",
                mediumturquoise:"#48d1cc",mediumvioletred:"#c71585",midnightblue:"#191970",mintcream:"#f5fffa",mistyrose:"#ffe4e1",
                moccasin:"#ffe4b5",navajowhite:"#ffdead",navy:"#000080",oldlace:"#fdf5e6",olive:"#808000",olivedrab:"#6b8e23",
                orange:"#ffa500",orangered:"#ff4500",orchid:"#da70d6",palegoldenrod:"#eee8aa",palegreen:"#98fb98",
                paleturquoise:"#afeeee",palevioletred:"#d87093",papayawhip:"#ffefd5",peachpuff:"#ffdab9",peru:"#cd853f",
                pink:"#ffc0cb",plum:"#dda0dd",powderblue:"#b0e0e6",purple:"#800080",red:"#ff0000",rosybrown:"#bc8f8f",
                royalblue:"#4169e1",saddlebrown:"#8b4513",salmon:"#fa8072",sandybrown:"#f4a460",seagreen:"#2e8b57",
                seashell:"#fff5ee",sienna:"#a0522d",silver:"#c0c0c0",skyblue:"#87ceeb",slateblue:"#6a5acd",slategray:"#708090",
                snow:"#fffafa",springgreen:"#00ff7f",steelblue:"#4682b4",tan:"#d2b48c",teal:"#008080",thistle:"#d8bfd8",
                tomato:"#ff6347",turquoise:"#40e0d0",violet:"#ee82ee",wheat:"#f5deb3",white:"#ffffff",whitesmoke:"#f5f5f5",
                yellow:"#ffff00",yellowgreen:"#9acd32"}

  before_save :check_logo_size

  # Translate named color into hex value and save.
  def bgcolor=(color)
    if color.starts_with?('#')
      super color
    else
      super COLORNAMES[color.to_s.gsub(/\W/,'').to_sym]
    end
  end

  def nav_bgcolor
    "#749242"
    #if color.starts_with?('#')
    #  super color
    #else
    #  super COLORNAMES[color.to_s.gsub(/\W/,'').to_sym]
    #end
  end

  def font_color=(color)
    if color.starts_with?('#')
      super color
    else
      super COLORNAMES[color.to_s.gsub(/\W/,'').to_sym]
    end
  end

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
      if bgcolor.to_s.starts_with?('#')
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

  # Not used anywhere yet.
  def calc_navbar_inverse
    if (calc_background_brightness < 130)
    end
  end

  def calc_border_color
    if (@border_color.nil?)
      @border_color = background_dark? ? "#ffffff" : "#000000"
    end
    @border_color
  end

  private #======================================================================

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