class MyStudio::Portrait < ActiveRecord::Base
  attr_accessible :image, :remote_image_url, :description, :active, :faces
  mount_uploader :image, AmazonUploader

  belongs_to :my_studio_session, :class_name => 'MyStudio::Session', :foreign_key => "my_studio_session_id"

  has_many :offers, :class_name => 'Admin::Customer::Offer'
  has_many :parts, :class_name => 'Admin::Merchandise::Part'
  has_many :faces, :class_name => 'MyStudio::Portrait::Face', :dependent => :destroy

  before_save :set_description

  after_save :get_faces

  # span text for Portrait
  def to_image_span
    text = description.to_s
    text = 'Portrait' if text.blank?
    text
  end

  def self.test
    test_areas = [[245, 290], [90, 137], [146, 146]]

    MyStudio::Portrait.all.each do |p|
      puts "portrait=>#{p.id}"
      p.faces.each do |face|

        p.dump_face(face.area_in_portrait, face)

        test_areas.each do |size|
          w = size.first
          h = size.last
          p.dump_face_area(face.center_in_area(w, h), face, w, h)
        end

      end if p.faces.present?
      p.resize_to_fit_and_center(245, 290)
    end
  end

  def resize_to_fit_and_center(dest_width, dest_height)
    raise 'forget to assign image?' unless image.present?
    # resize using aspect ratio of portrait
    resize = portrait_image.resize_to_fit!(dest_width, dest_height)
    img = center_in_area(resize, dest_width, dest_height)
    dump_resize(img, dest_width, dest_height)
    img
  end

  def dump_face(img, face)
    dump('face',img, "portrait_#{id}_face_#{face.id}.jpg")
  end

  def dump_face_area(img, face, width, height)
    dump('face', img, "portrait_#{id}_face_#{face.id}_size_#{width}_x_#{height}.jpg")
  end

  # the one and only portrait image scaled to 900x900 for faces.com
  def portrait_image
    @portrait_image ||= image.to_image(:face)
  end

  private

  def center_in_area(img, dest_width, dest_height)
    w = img.columns
    h = img.rows
    x = (dest_width - w) / 2 if w < dest_width
    y = (dest_height - h) / 2 if h < dest_height
    if x or y
      x         ||= 0
      y         ||= 0
      new_image = image_new(dest_width, dest_height).composite(img, x, y, Magick::AtopCompositeOp)
    end
    new_image ||= img
    new_image
  end

  def dump_resize(img, width, height)
    dump('resize', img, "portrait_#{id}_size_#{width}_x_#{height}.jpg")
  end

  def set_description
    if description.blank?
      if image_url.to_s.present?
        self.description = File.basename(image_url.to_s.split("?AWS").first).split('.').first
      end
    end
  end

  def get_faces
    if image_changed?
      gf = GetFace.new
      gf.perform(self)
    end
  end

end
