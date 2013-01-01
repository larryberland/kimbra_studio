class FacebookUser < ActiveRecord::Base
  attr_accessible :email, :name, :image_url, :oauth_expires_at, :oauth_token, :provider, :uid

  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
      user.provider         = auth.provider
      user.uid              = auth.uid
      user.name             = auth.info.name
      user.email            = auth.info.email
      user.image_url        = auth.info.image
      user.oauth_token      = auth.credentials.token
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

  #@graph.put_wall_post("explodingdog!",
  # {:name => "i love loving you",
  # :link => "http://www.explodingdog.com/title/ilovelovingyou.html"},
  # "tmiley")

  def share(offer, url)
    if share?
      hash = {
          message:     "#{offer.email.my_studio_session.studio.name} via Kimbra ClickPLUS",
          name:        offer.piece.name,
          caption:     offer.email.my_studio_session.studio.name,
          description: offer.piece.short_description,
          link:        url,
          picture:     offer.image_url}
      hash[:link] = "www.kimbraclickplus.com" unless Rails.env.production?

      facebook.put_wall_post("#{offer.email.my_studio_session.studio.name} via Kimbra ClickPLUS", hash)
    end
  rescue Koala::Facebook::APIError => e
    logger.info "FB:CHALLENGE:: #{e}"
    nil
  end

  def share_link(offer, url)
    if share?
      hash = {
          from: offer.email.my_studio_session.studio.name,
          link: url}
      hash[:link] = "www.kimbraclickplus.com" unless Rails.env.production?

      facebook.put_wall_post("Kimbra ClickPLUS", hash)
    end
  rescue Koala::Facebook::APIError => e
    logger.info "FB:CHALLENGE:: #{e}"
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

  def like(offer, url)
    if share?
      hash = {
          message:     "#{offer.email.my_studio_session.studio.name} via Kimbra ClickPLUS",
          name:        offer.piece.name,
          caption:     offer.email.my_studio_session.studio.name,
          description: offer.piece.short_description,
          link:        url,
          picture:     offer.image_url}
      hash[:link] = "www.kimbraclickplus.com" unless Rails.env.production?

      facebook.put_wall_post("#{offer.email.my_studio_session.studio.name} via Kimbra ClickPLUS", hash)
    end
  rescue Koala::Facebook::APIError => e
    logger.info "FB:CHALLENGE:: #{e}"
    nil
  end

end
