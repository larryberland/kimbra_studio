class MyStudio::Portrait < ActiveRecord::Base
  attr_accessible :image, :remote_image_url, :description, :active
  mount_uploader :image, AmazonUploader

  belongs_to :my_studio_session, :class_name => 'MyStudio::Session', :foreign_key => "my_studio_session_id"

  has_many :offers, :class_name => 'Admin::Customer::Offer'
  has_many :parts, :class_name => 'Admin::Merchandise::Part'

  before_save :set_description

  # span text for Portrait
  def to_image_span
    text = description.to_s
    text = 'Portrait' if text.blank?
    text
  end

  private

  def set_description
    if description.blank?
      self.description = File.basename(image_url.to_s.split("?AWS").first)
    end
  end


end
