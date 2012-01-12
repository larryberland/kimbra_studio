class Studio::Picture < ActiveRecord::Base
  attr_accessible :description, :image, :remote_image_url

  belongs_to :shoot
  has_many :offers, :class_name => 'Admin::Email::Offer'

  mount_uploader :image, ImageUploader

  before_save :set_description

  private

  def set_description
    if description.blank?
      self.description = image_url.to_s.split('/').last
    end
  end
end
