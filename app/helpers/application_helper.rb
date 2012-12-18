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
    link_to_with_current_local (t('.menu_shopping_cart') + " (#{ cart_numericality })").html_safe, url
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

  def link_to_your_collection_or_not(text, admin_customer_email)
    if is_client?
      link_to_with_current_local text, minisite_email_offers_path(admin_customer_email.tracking)
    else
      link_to text, show_collection_my_studio_minisite_path(admin_customer_email.tracking)
    end
  end

  def link_to_your_charms_or_not(text, admin_customer_email)
    if is_client?
      link_to_with_current_local(text, index_charms_minisite_email_offers_path(admin_customer_email.tracking))
    else
      link_to text, show_charms_my_studio_minisite_path(admin_customer_email.tracking)
    end
  end

  def link_to_your_chains_or_not(text, admin_customer_email)
    if is_client?
      link_to_with_current_local(text, index_chains_minisite_email_offers_path(admin_customer_email.tracking))
    else
      link_to text, show_chains_my_studio_minisite_path(admin_customer_email.tracking)
    end
  end

  def link_to_your_about_or_not(text, admin_customer_email)
    link_to_with_current_local text, about_minisite_email_path(admin_customer_email.tracking), title: @studio.try(:name)
  end

  def link_to_your_cart_or_not
    if is_admin?
      link_to t('.menu_sessions'), admin_overview_path
    elsif is_studio?
      link_to t('.menu_sessions'), my_studio_sessions_path
    else
      link_for_shopping_cart_nav
    end
  end

  def link_to_your_facebook_or_not
    if Rails.env.development?
      if current_user_facebook
        link_to "Sign out Facebook", facebook_signout_path, id: "sign_out"
      else
        link_to image_tag("fb_login.png"), '/auth/facebook', {:style => "color: #{@studio.minisite.font_color}; text-decoration: dotted;"}
      end
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
          link_to_with_current_local link_text, minisite_offer_url(@admin_customer_offer)
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

  # controllers before_filter#navbar_active
  #   sets the menu symbol that should be set with css_class active
  def li_navbar(menu)
    css_class = (menu == @navbar_active) ? 'active' : ''
    content_tag(:li, {class: css_class}) do
      link_to_navbar(menu)
    end
  end

  # expect link_to name and title to be in
  #   locales
  #     shared/navbar/menus/#{menu}/name
  #     shared/navbar/menus/#{menu}/title
  def li_navbar_path(menu, link_path)
    css_class = menu == @navbar_active ? 'active' : ''
    content_tag(:li, {class: css_class}) do
      link_to(t(".menus.#{menu}.name"), link_path, title: t(".menus.#{menu}.title"))
    end
  end

  def navbar_dropdown(menu)
    name  = t(".menus.#{menu}.name")
    title = t(".menus.#{menu}.title")
    "<a href='#' class='dropdown-toggle', data-toggle='dropdown' title='#{title}'> #{name} <b class='caret'></b></a>"
  end

  # create a navbar dropdown menu item
  # menu => menu symbol in locales.en
  # link_path => route path for menu item
  # menu_en_path => locales.en path to parent menu item (ex. '.menus.misc')
  def navbar_dropdown_li(menu, link_path, menu_en_path)
    name         = t("#{menu_en_path}.#{menu}.name")
    title        = t("#{menu_en_path}.#{menu}.title")
    html_options = {class: menu == @navbar_active ? 'active' : ''}
    content_tag(:li, link_to(name, link_path, {title: title}), html_options)
  end

  # construct the navbar dropdown markup for our Misc Menu Item
  def li_navbar_dropdown_misc
    menu      = :misc

    # drop down list for the Misc menu
    sub_menus = {merchandise:   admin_merchandise_pieces_path,
                 infos_samples: samples_my_studio_infos_path,
                 stories:       admin_stories_path,
                 infos_faqs:    faq_my_studio_infos_path}

    dropdown_active = false
    menu_en_path    = ".menus.#{menu}"
    html_options    = {class: 'dropdown-menu'}
    # dropdown ul tag containing our sub_menu li tags
    ul              = content_tag(:ul, html_options) do

      dropdown_tags = sub_menus.collect do |sub_menu, link_path|
        dropdown_active = true if (sub_menu == @navbar_active)
        navbar_dropdown_li(sub_menu, link_path, menu_en_path)
      end

      dropdown_tags.join(" ").html_safe
    end

    html_options[:class] = 'dropdown'
    html_options[:class] += " active" if (menu == @navbar_active) or dropdown_active
    html = content_tag(:li, html_options) do
      "#{navbar_dropdown(menu)}#{ul}".html_safe
    end
    html.html_safe

  end

  def link_to_navbar(menu)
    text = t(".menu_#{menu}")
    if (is_mock? or @admin_customer_email.nil?)
      case menu
        when :about
          link_to t(".menu_#{menu}"), "#", title: @studio.name
        when :shopping_cart
          if (@link_back)
            link_to t('.menu_infos_samples'), samples_my_studio_infos_path
          else
            link_to text, "#"
          end
        when :facebook
          link_to image_tag("fb_login.png"), '#'
        else
          link_to text, "#"
      end
    else
      case menu
        when :collection
          link_to_your_collection_or_not(text, @admin_customer_email)
        when :charms
          link_to_your_charms_or_not(text, @admin_customer_email)
        when :chains
          link_to_your_chains_or_not(text, @admin_customer_email)
        when :about
          link_to_your_about_or_not(text, @admin_customer_email)
        when :shopping_cart
          link_to_your_cart_or_not
        when :facebook
          link_to_your_facebook_or_not
      end
    end
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

  def link_to_pinterest(offer)
    image_url   = offer.image.url_cache_buster
    page_url    = minisite_email_offers_url(offer.email) # studio: offer.email.my_studio_session.studio.info.website
    description = url_encode("Gorgeous photo jewelry from #{offer.email.my_studio_session.studio.name} (#{offer.email.my_studio_session.studio.info.website}).")
    link_to image_tag('https://assets.pinterest.com/images/PinExt.png', title: 'Pin It'),
            "http://pinterest.com/pin/create/button/?url=#{page_url}&media=#{image_url}&description=#{description}",
            class:         'pin-it-button',
            'count-layout' => 'none'
  end

  def icon_minisite(icon_class)
    icon_class += " icon-white" if @studio and @studio.background_dark?
    "<i class='#{icon_class}'></i>".html_safe
  end

  # override of button_to
  #   uses <button> tag instead of <input>
  #   allows an icon_class to show before the name
  def button_icon_to(icon_class, name, options = {}, html_options = {})

    html_options = html_options.stringify_keys
    convert_boolean_attributes!(html_options, %w( disabled ))

    method_tag = ''
    if (method = html_options.delete('method')) && %w{put delete}.include?(method.to_s)
      method_tag = tag('input', :type => 'hidden', :name => '_method', :value => method.to_s)
    end

    form_method          = method.to_s == 'get' ? 'get' : 'post'
    form_options         = html_options.delete('form') || {}
    form_options[:class] ||= html_options.delete('form_class') || 'button_to'

    remote = html_options.delete('remote')

    request_token_tag = ''
    if form_method == 'post' && protect_against_forgery?
      request_token_tag = tag(:input, :type => "hidden", :name => request_forgery_protection_token.to_s, :value => form_authenticity_token)
    end

    url  = options.is_a?(String) ? options : self.url_for(options)
    name ||= url

    html_options = convert_options_to_data_attributes(options, html_options)

    # start of platypus override
    html_options.merge!("type" => "submit", "class" => 'btn btn-success')

    # use a button tag instead of input
    button = content_tag(:button, html_options) do
      content_tag(:i, "", "class" => icon_class) + " #{name}"
    end
    # end of platypus override

    form_options.merge!(:method => form_method, :action => url)
    form_options.merge!("data-remote" => "true") if remote
    "#{tag(:form, form_options, true)}<div>#{method_tag}#{button}#{request_token_tag}</div></form>".html_safe
  end

  def most_recent_shipment_for(email)
    if email.carts.present?
      date = email.carts.collect{ |c| c.try(:shipping).try(:updated_at)}.compact.max
      if !!date
        "#{time_ago_in_words(date)} days ago"
      else
        ''
      end
    else
      ''
    end
  end

end