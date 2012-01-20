module Admin::Customer::EmailsHelper
  #<div class='image-thumb'>
  #  <%= "Offer #{offer.to_image_span}" %><br/>
  #  <%= image_tag_thumb(offer) %>
  #</div>
  def div_image_offer(offer)
    if offer
      content_tag(:div, :class => 'image-thumb') do
        span_text = offer.respond_to?(:to_image_span) ? offer.to_image_span : ''
        if span_text.blank? and Rails.env.development?
          span_text = "#{offer} implement to_image_span?" if span_text.blank? and Rails.env.development?
        end
        content_tag(:span, span_text, :class => 'image-text') +
            content_tag(:br) + image_tag_thumb(offer)
      end
    end
  end

end
