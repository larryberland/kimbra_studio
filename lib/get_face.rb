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
    r        = Crack::JSON.parse(response)

    puts "error=>#{r['error_code']} msg=>#{r['error_message']}" if r['error_code'].present?

    unless r['error_code'].present?
      photos = r['photos']
      #puts "usage=>#{r['usage'].inspect}"
      #puts "photos=>#{photos.inspect}"

      info   = photos.first
      #puts "info=>#{info.inspect}"

      tags   = info['tags']

      if tags and tags.length > 0
        # download the image locally first, and then read it

        fname = File.basename(portrait.image_url(:face).split("?AWS").first).split('.').first

        img     = Magick::Image.read(portrait.image_url(:face)).first
        img_dim = [img.columns, img.rows]

        # remove any previous face info
        portrait.faces.each do |face|
          face.destroy
        end if portrait.faces.present?

        # puts "tags size=>#{tags.size}"
        tags.each do |tag|
          #puts "tag keys=>#{tag.keys.join(', ')}"

          face         = MyStudio::Portrait::Face.from_tag(tag)

          #puts "eye_left =>#{tag['eye_left']}"
          face_topleft = {
              'x' => img.columns * tag['eye_left']['x']/100.0,
              'y' => img.rows * tag['eye_left']['y']/100.0
          }

          #puts "eye_right =>#{tag['eye_right']}"
          #puts "mouth_right =>#{tag['mouth_right']}"

          face_width   = img.columns * tag['eye_right']['x']/100.0 - face_topleft['x']
          face_height  = img.rows * tag['mouth_right']['y']/100.0 - face_topleft['y']

          new_face_img = Magick::Image.constitute(
              face_width, face_height,
              "RGB",
              img.dispatch(face_topleft['x'], face_topleft['y'],
                           face_width, face_height, 'RGB')
          )

          img.composite!(new_face_img.gaussian_blur(0, 5),
                         face_topleft['x'], face_topleft['y'], Magick::OverCompositeOp)

          face.face_top_left_x = face_topleft['x']
          face.face_top_left_y = face_topleft['y']
          face.face_width      = face_width
          face.face_height     = face_height
          face.save

          portrait.faces << face
        end

        portrait.save

        # center the face into our part
        #img.write("#{fname}-blurred.jpg")
      end
    end
  end
end
