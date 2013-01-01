module FacebookHelper
  def link_to_facebook(offer)
    if Rails.env.development?
      if current_user_facebook
        #link_to_facebook_login(offer) + link_to_facebook_like(offer)
        link_to_facebook_like(offer)
      else
        link_to_facebook_login(offer)
      end
    end
  end

  def link_to_facebook_login(offer)
    link_to image_tag("fb_login.png"),
            "/auth/facebook?display=popup&state=#{offer.id}",
            :class => "popup", :"data-width" => 600, :"data-height" => 400
  end

  def link_to_facebook_like(offer)

    link_to image_tag("facebook/like.png"),
            like_facebook_session_path(offer.id),
            remote: true,
            method: :post,
            title:  t(:facebook_like_title),
            id:     "like_facebook_#{offer.id}"

  end

end