module ClientMailerHelper

  def two_line_intro(email)
    text = "#{email.my_studio_session.client.name} - we designed some heirloom photo jewelry for you."
    # No need to split if it's short.
    return text if text.length < 50
    # Find the first space beyond the first half
    halfway = text.length/2 + text[text.length/2, text.length].index(' ')
    first_half = text[0, halfway]
    last_half = text[halfway+1, text.length]
    "#{first_half}<br>#{last_half}".html_safe
  end

  def studio_logo_max_460_width(studio)
     if studio.minisite.image_width > 460
       460
     else
       studio.minisite.image_width
     end
  end

  def studio_logo_max_460_height(studio)
    if studio.minisite.image_width > 460
      (studio.minisite.image_height * 460.0 / studio.minisite.image_width).to_i
    else
      studio.minisite.image_height
    end
  end

end