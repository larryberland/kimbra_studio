#require 'rubygems'
#require 'restclient'
#require 'crack'
#require 'rmagick'
require 'uri'

URL_FACE  = "http://api.face.com/faces/detect.json"
URL_IMAGE = 'http://farm3.staticflickr.com/2751/4204160273_8aa8a03fab_b.jpg'

class GetFace
  def initialize
    face        = YAML.load_file(Rails.root.join('config', 'click_face.yml'))
    @api_key    = face[:click_face]['api_key']
    @api_secret = face[:click_face]['api_secret']
  end

  def perform(portrait)
    #####  make API call

    response = RestClient.get(URL_FACE,
                              :params=>{:api_key    => @api_key,
                                        :api_secret => @api_secret,
                                        :urls       => URI.escape(portrait.image_url(:face))})
    puts response.inspect
    r = Crack::JSON.parse(response)
    puts "keys=>#{r.keys.join(', ')}"

    puts "status=>#{r['status']}"
    puts "error=>#{r['error_code']} msg=>#{r['error_message']}"
    puts "usage=>#{r['usage'].inspect}"

    photos = r['photos']
    puts "photos=>#{photos.inspect}"

    info = photos.first
    puts "info=>#{info.inspect}"

    tags = info['tags']

    if tags and tags.length > 0
      puts tags.inspect
      # download the image locally first, and then read it

      fname = File.basename(portrait.image_url(:face).split("?AWS").first).split('.').first

      img     = Magick::Image.read(portrait.image_url(:face)).first
      img_dim = [img.columns, img.rows]

      # remove any previous face info
      portrait.faces.each do |face|
        face.destroy
      end if portrait.faces.present?

      puts "tags size=>#{tags.size}"
      tags.each do |tag|
        puts "tag keys=>#{tag.keys.join(', ')}"
        puts "tag => #{tag.inspect}"
        portrait.faces << MyStudio::Portrait::Face.from_tag(tag)
        face_topleft = {
            'x' => img.columns * tag['eye_left']['x']/100.0,
            'y' => img.rows * tag['eye_left']['y']/100.0
        }

        face_width  = img.columns * tag['eye_right']['x']/100.0 - face_topleft['x']
        face_height = img.rows * tag['mouth_right']['y']/100.0 - face_topleft['y']

        new_face_img = Magick::Image.constitute(
            face_width, face_height,
            "RGB",
            img.dispatch(face_topleft['x'], face_topleft['y'],
                         face_width, face_height, 'RGB')
        )

        img.composite!(new_face_img.gaussian_blur(0, 5),
                       face_topleft['x'], face_topleft['y'], Magick::OverCompositeOp)
      end
      portrait.save

      # center the face into our part
      img.write("#{fname}-blurred.jpg")

    end
  end
end
