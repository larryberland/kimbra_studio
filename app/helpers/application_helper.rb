module ApplicationHelper

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
    date = date.in_time_zone("Eastern Time (US & Canada)").to_date if date.is_a?(Time)
    date.strftime('%b %d') if date.is_a?(Date)
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
  def cw_div_image_only(model_with_carrier_wave_image, options={})
    if model_with_carrier_wave_image
      options[:image]   ||= 'image'
      options[:version] ||= :thumb
      image_tag(cw_url(model_with_carrier_wave_image, options[:image], options[:version]))
    end
  end

  def link_for_shopping_cart_nav
    url               = '#'
    cart_numericality = '0 pieces'
    if (is_client?)
      url               = shopping_cart_path(@cart.tracking)
      cart_numericality = content_tag :span, :id => :cart_numericality do
        pluralize(@cart.try(:quantity), 'piece')
      end
    end
    link_to_unless_current (t('.menu_shopping_cart') + " (#{ cart_numericality })").html_safe, url
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
        edit_minisite_item_side_path(offer.items.first.front)
      end
    else
      minisite_offer_url(offer)
    end
  end

  def link_to_your_collection_or_not(admin_customer_email)
    # LDB: NOTE:  if this helper is called from any other erb
    #   than shared/minisite_header not sure if the translations will work
    if is_client?
      link_to_unless_current t('.menu_collection'), minisite_email_offers_path(admin_customer_email.tracking)
    else
      link_to t('.menu_collection'), show_collection_my_studio_minisite_path(admin_customer_email.tracking)
    end
  end

  def link_to_your_charms_or_not(admin_customer_email)
    text = t('.menu_charms')
    if is_client?
      link_to_unless_current(text, index_charms_minisite_email_offers_path(admin_customer_email.tracking))
    else
      link_to text, show_charms_my_studio_minisite_path(admin_customer_email.tracking)
    end
  end

  def link_to_your_chains_or_not(admin_customer_email)
    text = t('.menu_chains')
    if is_client?
      link_to_unless_current(text, index_chains_minisite_email_offers_path(admin_customer_email.tracking))
    else
      link_to text, show_chains_my_studio_minisite_path(admin_customer_email.tracking)
    end
  end

# Show a link to the current offer - no need for this if we are at the Collection page or if there's no current offer.
# NOT USED ANYMORE.
  def link_back_to_current_offer
    if @admin_customer_offer
      at_collection_page = controller_name == 'offers' && action_name == 'index'
      at_shopping_page   = %w(carts addresses shippings items purchases stripe_cards).include?(controller_name)
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
    is_admin? ? link_to(t(:destroy), url, confirm: t(:link_destroy_confirm), method: :delete) : ''
  end

  def css_button(selected)
    css = '' # usually likeabutton
    css += ' selected' if selected
    css
  end

  def link_to_nav_pill(label, url, selected, title="")
    css_class = selected ? {class: 'active'} : {}
    html      = content_tag(:li, css_class) do
      link_to(label, url, title: title)
    end
    html.html_safe
  end

  def link_to_nav_drop_down(label, url, selected, title="")
    css_class = {class: "dropdown-menu"}
    css_class[:class] += " active" if selected
    html = content_tag(:ul, css_class) do
      link_to(label, url, title: title)
    end
    html.html_safe
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

end