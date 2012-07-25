module ApplicationHelper

  def is_admin?
    current_user and current_user.admin?
  end

  def studio_name
    @my_studio.try(:name)
  end

  def site_name
    I18n.t(:company)
  end

  def time_short(time)
    # TODO: add time_zone entry to user table so we can display users time_zone
    at = time.nil? ? Time.now : time
    l(at.in_time_zone("Eastern Time (US & Canada)"), format: :show)
  end

  def image_tag_title(image_url)

  end

  def to_size(model)
    "#{model.try(:width)}x#{model.try(:height)}"
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
  # NOT USED ANYMORE.
  def link_back_to_current_offer
    if @admin_customer_offer
      at_collection_page = controller_name == 'offers' && action_name == 'index'
      at_shopping_page   = %w(carts addresses shippings items purchases strip_cards).include?(controller_name)
      at_offer_page      = controller_name == 'offers' && action_name == 'show'
      link_text          = at_offer_page ? @admin_customer_offer.name : "Return to #{@admin_customer_offer.name}"
      unless at_collection_page or at_shopping_page
        link = content_tag :li do
          link_to_unless_current link_text, minisite_offer_url(@admin_customer_offer)
        end
        (" | " + link).html_safe
      end
    end
  end

  # Dynamically constrain image size to 500px wide.
  # offer must respond to #width and #height
  # dimension must be :width or :height
  def constrain_to_500_px_wide(offer, dimension)
    if offer.width.to_i <= 500
      return "#{offer.width}px" if dimension == :width
      return "#{offer.height}px" if dimension == :height
    else
      case dimension
        when :width
          "500px"
        when :height
          height = (500.0 / offer.width.to_i * offer.height.to_i).to_i
          "#{height}px"
      end
    end
  end

  def link_to_destroy(url)
    is_admin? ? link_to( t(:destroy), url, confirm: t(:link_destroy_confirm), method: :delete) : ''
  end
end