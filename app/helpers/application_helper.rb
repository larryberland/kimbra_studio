module ApplicationHelper

  def is_mock?
    @is_mock_navbar = params[:controller] == 'my_studio/infos' ? true : false if @is_mock_navbar.nil?
    @is_mock_navbar
  end

  def is_admin?
    defined?(current_user) and current_user and current_user.admin?
  end

  def is_studio?
    defined?(current_user) and current_user and current_user.studio?
  end

  def is_client?
    (is_admin? or is_studio?) ? false : true
  end

  def studio_name
    @my_studio.try(:name)
  end

  # @admin_customer_friend identifies the client's
  #   friend info for this session
  def in_my_collection?(offer)
    if (@admin_customer_friend)
      if (offer.suggestion?)
        false
      elsif (offer.friend and offer.friend.id != @admin_customer_friend.id)
        false
      else
        true
      end
    end
  end

  def site_name
    I18n.t(:company)
  end

  def nav_bar_title
    title = if user_signed_in?
              if is_admin?
                t(:admin_overview_title)
              else
                @my_studio.try(:name)
              end

            end
    title ||= t(:company_brand)
    title
  end

  # return blank if no time
  def time_short(time)
    # TODO: add time_zone entry to user table so we can display users time_zone
    time.nil? ? '' : l(time.in_time_zone("Eastern Time (US & Canada)"), format: :show)
  end

  def time_short_index(time)
    # TODO: add time_zone entry to user table so we can display users time_zone
    time.nil? ? '' : l(time.in_time_zone("Eastern Time (US & Canada)"), format: :index)
  end

  # return Time.now if no time
  def time_short_now(time)
    # TODO: add time_zone entry to user table so we can display users time_zone
    at = time.nil? ? Time.now : time
    l(at.in_time_zone("Eastern Time (US & Canada)"), format: :show)
  end

  def date_short(date)
    case date
      when Time
        date_short = date.in_time_zone("Eastern Time (US & Canada)").to_date.strftime('%b %d')
        tooltip = date.in_time_zone("Eastern Time (US & Canada)").to_s(:long_tz)
      when Date
        date_short = date.strftime('%b %d')
        tooltip = date.strftime('%b %d, %Y')
      when NilClass
        date_short = nil
        tooltip = nil
      else
        date_short = date
        tooltip = 'could not recognize this date'
    end
    content_tag :span, title: tooltip do
      date_short
    end
  end

  def image_tag_title(image_url)

  end

  def to_size(model)
    "#{model.try(:width)}x#{model.try(:height)}"
  end

  # show.html
  def image_tag_thumb(model_with_carrier_wave_image)
    url = model_with_carrier_wave_image.image_url(:thumb).to_s rescue nil
    url = 'spacer.gif' if url.blank?
    image_tag url, alt: 'studio logo'
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
  #  <%= image_tag_version(model) %>
  #</div>
  def cw_image_only(model_with_carrier_wave_image, options={})
    if model_with_carrier_wave_image
      options[:image]   ||= 'image'
      options[:version] ||= :thumb
      image_tag(cw_url(model_with_carrier_wave_image, options[:image], options[:version]), class: "img-rounded")
    end
  end

  def url_for_offer_or_not(offer)
    # currently opening this offer up for amyone to change
    #  may re-think this later on security or Save issues
    minisite_offer_url(offer)
  end

  # on image do some workflow for the admin user
  def url_for_offer_or_not_image(offer)
    # currently opening this offer up for amyone to change
    #  may re-think this later on security or Save issues
    if (is_admin?)
      # go directly to Adjust Picture
      offer.has_picture?
      if offer.items.size > 1
        minisite_offer_items_path(offer)
      else
        if offer.items.first
          edit_minisite_item_side_path(offer.items.first.front)
        else
          minisite_offer_items_path(offer)
        end
      end
    else
      minisite_offer_url(offer)
    end
  end

  def link_to_with_current_local(name, options = {}, html_options = {}, &block)
    if current_page?(options)
      link_to name, '#', html_options, &block
    else
      link_to name, options, html_options, &block
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
    is_admin? ? link_to(t(:destroy), url, confirm: t(:link_destroy_confirm), method: :delete) : ''
  end

  def css_button(selected)
    css = '' # usually likeabutton
    css += ' selected' if selected
    css
  end

  def link_to_button(label, url, selected, title="")
    css = css_button(selected)
    link_to label, url, class: css, title: title
  end

# allows word wrapping on email strings
  def email_display(email)
    email.to_s.downcase.gsub('@', "&#8203;@").gsub('.', "&#8203;.").html_safe
  end

  def link_from_site_short_name(url)
    host   = URI.parse(url).host.downcase
    host   = host.start_with?('www.') ? host[4..-1] : host
    result = host.split('.').first
    link_to result, url, target: '_blank', title: url
  rescue
    'none'
  end

  def current_status(active_flag)
    active_flag ? "active" : "inactive"
  end

  def table_friendly_email(email)
    email.to_s.gsub(/([@.])/, '\1@&thinsp;').html_safe
  end

  def link_to_pinterest(offer)
    return nil unless offer.email.my_studio_session.studio.info.pinterest_for_clients
    image_url   = offer.image.url_cache_buster
    page_url    = minisite_email_offers_url(offer.email) # studio: offer.email.my_studio_session.studio.info.website
    description = url_encode("Gorgeous photo jewelry from #{offer.email.my_studio_session.studio.name} (#{offer.email.my_studio_session.studio.info.website}).")
    link_to image_tag('https://assets.pinterest.com/images/PinExt.png', title: 'Pin It'),
            "http://pinterest.com/pin/create/button/?url=#{page_url}&media=#{image_url}&description=#{description}",
            class: 'pin-it-button',
            'count-layout' => 'none'
  end

  def icon_minisite(icon_class)
    icon_class += " icon-white" if @studio and @studio.background_dark?
    "<i class='#{icon_class}'></i>".html_safe
  end

end