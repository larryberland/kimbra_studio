module FacebookHelper
  def link_to_facebook(offer)
    if Rails.env.development?
      link_to_facebook_like(offer) + link_to_facebook_share(offer)
    end
  end

  def link_to_facebook_like(offer)
    link_to image_tag("facebook/like.png"),
            like_facebook_session_path(offer.id),
            remote: true,
            method: :post,
            title:  t(:facebook_like_title),
            id:     "like_facebook_#{offer.id}"

  end

  def link_to_facebook_share(offer)
    link_to image_tag("facebook/send.png"),
            share_facebook_session_path(offer.id),
            remote: true,
            method: :post,
            title:  t(:facebook_share_title),
            id:     "share_facebook_#{offer.id}"
  end


end