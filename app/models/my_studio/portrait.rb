class MyStudio::Portrait < ActiveRecord::Base
  attr_accessible :description, :active, :image, :remote_image_url

  belongs_to :my_studio_session, :class_name => 'MyStudio::Session', :foreign_key => "my_studio_session_id"

  has_many :offers, :class_name => 'Admin::Customer::Offer'
  has_many :parts, :class_name => 'Admin::Merchandise::Part'

  mount_uploader :image, ImageUploader

  before_save :set_description

  private

  def set_description
    if description.blank?
      self.description = image_url.to_s.split('/').last
    end
  end

end
