module ApplicationHelper
  def site_name
    I18n.t(:company)
  end

  def image_tag_title(image_url)

  end

  # show.html
  def image_tag_thumb(model_with_carrier_wave_image)
    url = model_with_carrier_wave_image.image_url(:thumb).to_s rescue ''
    image_tag url
  end

  def image_tag_list(model_with_carrier_wave_image)
    url = model_with_carrier_wave_image.image_url(:list).to_s rescue ''
    image_tag url
  end

  def cw_url(model_with_carrier_wave_image, image_attr, image_version)
    case image_version
      when :original
        model_with_carrier_wave_image.send("#{image_attr}_url").to_s rescue ''
      else
        model_with_carrier_wave_image.send("#{image_attr}_url", image_version).to_s rescue ''
    end
  end

  #  <span><%= model.to_image_span %></span>
  def cw_span(model_with_carrier_wave_image)
    span_text = model_with_carrier_wave_image.try(:to_image_span)
    span_text = "#{model_with_carrier_wave_image} implement to_image_span?" if span_text.blank? and Rails.env.development?
    content_tag(:span, span_text, :class => 'image-text')
  end

  #<div class='image-thumb'>
  #  <span><%= model.to_image_span %></span><br/>
  #  <%= image_tag_version(model) %>
  #</div>
  def cw_div_image(model_with_carrier_wave_image, options={})
    if model_with_carrier_wave_image
      options[:image]   ||= 'image'
      options[:version] ||= :thumb
      content_tag(:div, :class => 'image-thumb') do
        cw_span(model_with_carrier_wave_image) +
            content_tag(:br) +
            image_tag(cw_url(model_with_carrier_wave_image, options[:image], options[:version]))
      end
    end
  end

  #<div class='image-thumb'>
  #  <span><%= model.to_image_span %></span><br/>
  #  <%= image_tag_version(model) %>
  #</div>
  def cw_div_image_only(model_with_carrier_wave_image, options={})
    if model_with_carrier_wave_image
      options[:image]   ||= 'image'
      options[:version] ||= :thumb
      image_tag(cw_url(model_with_carrier_wave_image, options[:image], options[:version]))
    end
  end

  def link_for_shopping_cart_nav
    cart_numericality = content_tag :span, :id => :cart_numericality do
      pluralize(@cart.quantity, 'piece')
    end
    link_to_unless_current (t(:minisite_menu_shopping_cart_link) + " (#{ cart_numericality })").html_safe,
                           shopping_cart_path(@cart.tracking)
  end

  # Show a link to the current offer - no need for this if we are at the Collection page or if there's no current offer.
  def link_back_to_current_offer
    if @admin_customer_offer
      at_collection_page = controller_name == 'offers' && action_name == 'index'
      at_shopping_page   = %w(carts addresses items purchases strip_cards).include?(controller_name)
      at_offer_page      = controller_name == 'offers' && action_name == 'show'
      link_text          = at_offer_page ? @admin_customer_offer.name : "Return to #{@admin_customer_offer.name}"
      unless at_collection_page or at_shopping_page
        link = content_tag :li do
          link_to_unless_current link_text, minisite_offer_url(@offer)
        end
        (" | " + link).html_safe
      end
    end
  end

end