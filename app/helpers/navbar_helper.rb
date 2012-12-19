module NavbarHelper

  # create a navbar menu markup for a bootstrap li tag
  # menu => menu symbol in locales.en
  # link_path => route path for menu item
  # menu_en_path => locales.en path to parent menu item (ex. '.menus.misc')
  def li_navbar(menu, link_path, menu_en_path=".menus")

    name_method = "navbar_#{menu}_name"
    name = send(name_method) if respond_to?(name_method.to_sym, include_private=true)
    name ||= t("#{menu_en_path}.#{menu}.name")

    title_method = "navbar_#{menu}_title"
    title = send(title_method) if respond_to?(title_method.to_sym, include_private=true)
    title ||= t("#{menu_en_path}.#{menu}.title")

    link_options = {title: title}
    link_options[:class] = "brand" if menu == :brand
    html_options = {class: menu == @navbar_active ? 'active' : ''}
    content_tag(:li, link_to(name, link_path, link_options), html_options).html_safe
  end

  # controllers before_filter#navbar_active
  #   sets the menu symbol that should be set with css_class active
  def li_navbar_or_not(menu)
    # path for the navbar menu item
    path_method = "navbar_#{menu}_path"
    path = send(path_method) if respond_to?(path_method.to_sym, include_private=true)
    path = '#' if path and current_page?(path) # if the current request is this path then stub it out with #
    path ||= "#"
    li_navbar(menu, path)
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

  private

  # Customize navbar Menu Items
  #   path, name, or title

  def navbar_about_path
    if @admin_customer_email
      #link_to_your_about_or_not(text, @admin_customer_email)
      about_minisite_email_path(@admin_customer_email.tracking)
    else
      '#'
    end
  end

  # customize about menu title text
  def navbar_about_title
    t('.menus.about.title', name: @studio.try(:name))
  end

  # customize about menu title text
  def navbar_brand_title
    t('.menus.brand.title', name: @studio.try(:name))
  end

  # minisite menu options for returning
  #   the link_path for this menu item
  def navbar_collection_path
    if @admin_customer_email
      #link_to_your_collection_or_not(text, @admin_customer_email)
      if is_client?
        minisite_email_offers_path(@admin_customer_email.tracking)
      else
        show_collection_my_studio_minisite_path(@admin_customer_email.tracking)
      end
    else
      '#'
    end
  end

  def navbar_charms_path
    if @admin_customer_email
      #link_to_your_charms_or_not(text, @admin_customer_email)
      if is_client?
        index_charms_minisite_email_offers_path(@admin_customer_email.tracking)
      else
        show_charms_my_studio_minisite_path(@admin_customer_email.tracking)
      end
    else
      '#'
    end
  end

  def navbar_chains_path
    if @admin_customer_email
      # link_to_your_chains_or_not(text, @admin_customer_email)
      if is_client?
        index_chains_minisite_email_offers_path(@admin_customer_email.tracking)
      else
        show_chains_my_studio_minisite_path(@admin_customer_email.tracking)
      end
    else
      '#'
    end
  end

  def navbar_facebook_path
    #link_to_your_facebook_or_not
    if Rails.env.development?
      if current_user_facebook
        facebook_signout_path
      else
        '/auth/facebook'
      end
    else
      '#'
    end
  end

  # customize with an image
  def navbar_facebook_name
    if Rails.env.development?
      if current_user_facebook
        t('.menus.facebook.sign_out.name')
      else
        image_tag("fb_login.png")
      end
    else
      ''
    end
  end

  def navbar_facebook_title
    if Rails.env.development?
      if current_user_facebook
        t('.menus.facebook.sign_out.title')
      else
        t('.menus.facebook.title')
      end
    else
      ''
    end
  end

  def navbar_shopping_cart_path
    #link_to_your_cart_or_not
    if is_admin?
      admin_overview_path
    elsif is_studio?
      my_studio_sessions_path
    else
      shopping_cart_path(@cart.tracking)
    end
  end

  # customize the navbar name for shopping_cart
  def navbar_shopping_cart_name
    if @link_back
      t('.menus.shopping_cart.mock.name')
    else
      if is_admin?
        t('.menus.shopping_cart.admin.name')
      elsif is_studio?
        t('.menus.shopping_cart.studio.name')
      else
        if @cart

          cart_numericality = content_tag(:span, id: :cart_numericality) do
            pluralize(@cart.try(:quantity), 'piece')
          end
          "#{icon_minisite("icon-shopping-cart")} #{t('.menus.shopping_cart.name')} #{cart_numericality}".html_safe
        else
          Rails.logger.info("KCP::navbar_shopping_cart_name() called without a @cart attribute.")
          t('.menus.shopping_cart.name')
        end
      end
    end
  end

  def navbar_shopping_cart_title
    if @link_back
      t('.menus.shopping_cart.mock.title')
    else
      if is_admin?
        t('.menus.shopping_cart.admin.title')
      elsif is_studio?
        t('.menus.shopping_cart.studio.title')
      else
          t('.menus.shopping_cart.title')
      end
    end
  end

end

