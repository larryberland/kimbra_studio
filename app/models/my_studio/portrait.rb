class MyStudio::Portrait < ActiveRecord::Base

  attr_accessible :image, :remote_image_url, :description, :active, :faces,
                  :my_studio_session, :my_studio_session_id

  mount_uploader :image, AmazonUploader

  belongs_to :my_studio_session, :class_name => 'MyStudio::Session', :foreign_key => "my_studio_session_id"

  has_many :offers, :class_name => 'Admin::Customer::Offer'
  has_many :parts, :class_name => 'Admin::Merchandise::Part'
  has_many :faces, :class_name => 'MyStudio::Portrait::Face', :dependent => :destroy

  scope :last, order('created_at desc').limit(1)
  scope :last_2_hours, where(created_at: 2.hours.ago..Time.now)

  before_save :set_description
  after_save :get_faces

  def face_image
    if @face_image.nil?
      raise "who is calling me face_image"
      @face_image, @face_file = create_image_temp(base_filename='face') do
        portrait_image
      end
    end
    @face_image
  end

  def face_file
    # LDB:? some reason we call this face_file but we are returning
    #       an image it looks like
    if @face_file.nil?
      if Rails.env.test?
        @face_image, @face_file = create_image_temp(base_filename='face') do
          portrait_image
        end
      else
        portrait_image_url
      end
    end
    @face_file
  end

  # span text for Portrait
  def to_image_span
    text = description.to_s
    text = 'Portrait' if text.blank?
    text
  end

  # the one and only portrait image scaled to 900x900 for faces.com
  def portrait_image
    @portrait_image ||= image.to_image(:face)
  end

  private #===============================================================================

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