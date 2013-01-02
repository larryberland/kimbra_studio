module FacebookHelper

  def link_to_facebook(offer)
    return nil unless offer.email.my_studio_session.studio.info.facebook_for_clients
    link_to_facebook_login(offer)
  end

  def link_to_facebook_login(offer)
    return nil unless offer.email.my_studio_session.studio.info.facebook_for_clients
    link_to image_tag("fb_login.png"),
            "/auth/facebook?display=popup&state=#{offer.id}",
            :class => "popup", :"data-width" => 600, :"data-height" => 400
  end

  def link_to_facebook_like(offer)
    return nil unless offer.email.my_studio_session.studio.info.facebook_for_clients
    link_to image_tag("facebook/like.png"),
            like_facebook_session_path(offer.id),
            remote: true,
            method: :post,
            title: t(:facebook_like_title),
            id: "like_facebook_#{offer.id}"

  end

end