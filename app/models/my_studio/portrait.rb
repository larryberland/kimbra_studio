class MyStudio::Portrait < ActiveRecord::Base
  attr_accessible :image, :remote_image_url, :description, :active, :faces
  mount_uploader :image, AmazonUploader

  belongs_to :my_studio_session, :class_name => 'MyStudio::Session', :foreign_key => "my_studio_session_id"

  has_many :offers, :class_name => 'Admin::Customer::Offer'
  has_many :parts, :class_name => 'Admin::Merchandise::Part'
  has_many :faces, :class_name => 'MyStudio::Portrait::Face', :dependent => :destroy

  before_save :set_description

  # span text for Portrait
  def to_image_span
    text = description.to_s
    text = 'Portrait' if text.blank?
    text
  end

  def self.test
    MyStudio::Portrait.all.each do |p|
      #p.faces.each do |face|
      #  p.center_on_face(face, 200, 300)
      #end if p.faces.present?
      p.resize_to_fit_and_center(245, 290)
    end
  end

  # center this face inside this area
  def center_on_face(face, dest_width, dest_height)
    p = Rails.root.join('public', 'test')
    p.mkpath unless File.exist?(p.to_s)
    puts "portrait=>#{id}"
    # put the face area onto portrait
    face.area_in_portrait.write(p.join("portrait_#{id}_face_#{face.id}_area.jpg").to_s)
    face.center_in_area(245, 290).write(p.join("portrait_#{id}_face_#{face.id}_245x290.jpg").to_s)
    face.center_in_area(90, 137).write(p.join("portrait_#{id}_face_#{face.id}_90x137.jpg").to_s)
  end

  def resize_to_fit_and_center(dest_width, dest_height)
    raise 'forget to assign image?' unless image.present?

    # resize using aspect ratio of portrait
    resize = Magick::Image.read(image_url).first.resize_to_fit!(dest_width, dest_height)

    img = center_in_area(resize, dest_width, dest_height)
    img.write(path('resize').join("portrait_#{id}_#{dest_width}_x_#{dest_height}_resize.jpg").to_s) if Rails.env.development?
    img
  end

  private

  def path(dir)
    p = Rails.root.join('public', dir)
    p.mkpath unless File.exists?(p.to_s)
    p
  end

  def center_in_area(img, dest_width, dest_height)
    w = img.columns
    h = img.rows
    x = (dest_width - w) / 2 if w < dest_width
    y = (dest_height - h) / 2 if h < dest_height
    if x or y
      x         ||= 0
      y         ||= 0
      new_image = Magick::Image.new(dest_width, dest_height).composite(img, x, y, Magick::AtopCompositeOp)
    end
    new_image ||= img
    new_image
  end

  def set_description
    if description.blank?
      if image_url.to_s.present?
        self.description = File.basename(image_url.to_s.split("?AWS").first).split('.').first
      end
    end
  end


end
