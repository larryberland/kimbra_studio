module Admin::Customer::EmailsHelper
  #<div class='image-thumb'>
  #  <%= "Offer #{offer.try(:piece).try(:name)}" %><br/>
  #  <%= image_tag_thumb(offer) %>
  #</div>
  def div_image_offer(offer)
    content_tag(:div, :class => 'image-thumb') do
      content_tag(:span, offer.try(:piece).try(:name), :class =>'image-text') +
      content_tag(:br) +
      image_tag_thumb(offer)
    end
  end

end
