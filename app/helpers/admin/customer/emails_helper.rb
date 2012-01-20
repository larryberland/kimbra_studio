module Admin::Customer::EmailsHelper

  def carrier_wave_url(model_with_carrier_wave_image, image_attr, image_version)
    case image_version
      when :original
        model_with_carrier_wave_image.send("#{image_attr}_url").to_s rescue ''
      else
        model_with_carrier_wave_image.send("#{image_attr}_url", image_version).to_s rescue ''
    end
  end

  #<div class='image-thumb'>
  #  <%= "Offer #{offer.to_image_span}" %><br/>
  #  <%= image_tag_thumb(offer) %>
  #</div>
  def div_image_offer(offer, options={})
    if offer
      options[:image]   ||= 'image'
      options[:version] ||= :thumb
      content_tag(:div, :class => 'image-thumb') do
        span_text = offer.respond_to?(:to_image_span) ? offer.to_image_span : ''
        span_text = "#{offer} implement to_image_span?" if span_text.blank? and Rails.env.development?
        content_tag(:span, span_text, :class => 'image-text') +
            content_tag(:br) +
            image_tag(carrier_wave_url(offer, options[:image], options[:version]))
      end
    end
  end
end
