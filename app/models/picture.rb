class Picture < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  mount_uploader :avatar, AmazonUploader

  belongs_to :my_studio_session, :class_name => 'MyStudio::Session', :foreign_key => "my_studio_session_id"

  attr_accessor :file  # not sure if i need this

  attr_accessible :file, :avatar, :remote_avatar_url, :active,
                  :my_studio_session, :my_studio_session_id


  #one convenient method to pass jq_upload the necessary information
  def to_jq_upload
    {
      "name" => read_attribute(:avatar),
      "size" => avatar.size,
      "url" => avatar.url,
      "thumbnail_url" => avatar.thumb.url,
      "delete_url" => picture_path(:id => id),
      "delete_type" => "DELETE"
    }
  end
end
