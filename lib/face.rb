require 'rubygems'
require 'restclient'
require 'crack'
require 'rmagick'

URL_FACE  = "http://api.face.com/faces/detect.json"
URL_IMAGE = 'http://farm3.staticflickr.com/2751/4204160273_8aa8a03fab_b.jpg'


class Face
  def initialize
    face        = YAML.load_file(Rails.root.join('config', 'click_face.yml'))
    @api_key    = face[:click_face]['api_key']
    @api_secret = face[:click_face]['api_secret']

  end

  def perform(portrait)


    #####  make API call
    response = RestClient.get(URL_FACE,
                              :params=>{:api_key=>@api_key,
                                        :api_secret=>@api_secret,
                                        :urls   => portrait.image.file.file})
    puts response.inspect
    tags = Crack::JSON.parse(response)['photos'][0]['tags']

    puts tags.inspect
    if tags.length > 0
      # download the image locally first, and then read it

      fname = File.basename(portrait.image_url)

      img     = Magick::Image.read(portrait.image.file.file).first
      img_dim = [img.columns, img.rows]

      tags.each do |tag|
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

      img.write("#{fname}-blurred.jpg")

    end
  end
end
