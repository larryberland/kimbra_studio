class FacebookUser < ActiveRecord::Base
  attr_accessible :email, :name, :image_url, :oauth_expires_at, :oauth_token, :provider, :uid

  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.email = auth.info.email
      user.image_url = auth.info.image
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.save!
    end
  end

  # usage
  # u = FacebookUser.first
  # u.facebook.get_object("me")
  # u.facebook.get_connection("me", "television")
  # u.facebook.get_connection("me", "permissions")
  def facebook
    @facebook ||= Koala::Facebook::API.new(oauth_token)
  end

  def share(offer)
    if share?
      facebook.put_wall_post("testing KimbraClickPLUS")
    end
  rescue Koala::Facebook::APIError => e
    logger.info e.to_s
    nil
  end

  def permissions
    @permissions ||= facebook.get_connection("me", "permissions").first
    puts @permissions.inspect
    @permissions
  end

  def share?
    permissions["publish_stream"] == 1 ? true : false if permissions.keys.include?("publish_stream")
  end

end
