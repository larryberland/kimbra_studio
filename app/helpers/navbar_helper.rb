module NavbarHelper

  # create a navbar menu markup for a bootstrap li tag
  # menu => menu symbol in locales.en
  # link_path => route path for menu item
  # menu_en_path => locales.en path to parent menu item (ex. '.menus.misc')
  def li_navbar(menu, link_path, en_path=".menus")

    name_method = "navbar_#{menu}_name"
    name = send(name_method) if respond_to?(name_method.to_sym, include_private=true)
    name ||= t("#{en_path}.#{menu}.name")

    title_method = "navbar_#{menu}_title"
    title = send(title_method) if respond_to?(title_method.to_sym, include_private=true)
    title ||= t("#{en_path}.#{menu}.title")

    link_options = {title: title}
    link_options[:class] = "brand" if menu == :brand
    html_options = {class: menu == @navbar_active ? 'active' : ''}
    content_tag(:li, link_to(name, link_path, link_options), html_options).html_safe
  end

  # controllers before_filter#navbar_active
  #   sets the menu symbol that should be set with css_class active
  #
  # li_navbar_or_not(:collection) =>
  #
  #   <li class="active">
  #     <a title="Click to view your custom jewelry collection"
  #         href="/minisite/emails/hydh0yezkf/offers">
  #       Your Collection
  #     </a>
  #   </li>
  def li_navbar_or_not(menu)
    # path for the navbar menu item
    path_method = "navbar_#{menu}_path"
    path = send(path_method) if respond_to?(path_method.to_sym, include_private=true)
    path = '#' if path and current_page?(path) # if the current request is this path then stub it out with #
    path ||= "#"
    li_navbar(menu, path)
  end

  # top level navbar menu that contains a sub_menu
  # dropdown_active sets the menu item highlighted when true
  def li_navbar_dropdown_menu(menu, ul_sub_menu_html, dropdown_active)
    html_options = {class: 'dropdown'}
    html_options[:class] += " active" if (menu == @navbar_active) or dropdown_active

    html = content_tag(:li, html_options) do
      "#{navbar_dropdown(menu)}#{ul_sub_menu_html}".html_safe
    end
    html.html_safe
  end

  # construct the navbar dropdown markup for our Misc Menu Item
  def li_navbar_misc
    menu      = :misc

    # drop down list for the Misc menu
    sub_menus = {merchandise:   admin_merchandise_pieces_path,
                 infos_samples: samples_my_studio_infos_path,
                 stories:       admin_stories_path,
                 infos_faqs:    faq_my_studio_infos_path}

    dropdown_active, sub_menu_html = navbar_dropdown_sub_menus(menu, sub_menus)

    li_navbar_dropdown_menu(menu, sub_menu_html, dropdown_active)

  end

  def li_navbar_photo_sessions
    menu = :photo_sessions
    unless is_client?
      if @mock_collection.nil? or (@mock_collection == :return)
        li_navbar_or_not(menu)
      end
    else
      ''
    end
  end

  private

  # top level navbar menu that has dropdown menus
  def navbar_dropdown(menu)
    name  = t(".menus.#{menu}.name")
    title = t(".menus.#{menu}.title")
    "<a href='#' class='dropdown-toggle' data-toggle='dropdown' title='#{title}'> #{name} <b class='caret'></b></a>"
  end

  # generates the sub_menu_html for all sub_menus items
  # returns dropdown_active => true if this sub_menu is currently active
  # the sub_menu_html markup for everything in the sub_menus hash
  # sub_menus => {menu_symbol: link_path_for_sub_menu}
  def navbar_dropdown_sub_menus(menu, sub_menus)
    dropdown_active = false
    en_path         = ".menus.#{menu}"
    html_options    = {class: 'dropdown-menu'}

    # dropdown ul tag containing our sub_menu li tags
    sub_menu_html   = content_tag(:ul, html_options) do

      li_navbars = sub_menus.collect do |sub_menu, link_path|
        dropdown_active = true if (sub_menu == @navbar_active)
        li_navbar(sub_menu, link_path, en_path)
      end
      li_navbars.join(" ").html_safe
    end
    return dropdown_active, sub_menu_html
  end


  # Customize navbar Menu Items
  #   path, name, or title

  def navbar_brand_path
    if @admin_customer_email
      #link_to_your_about_or_not(text, @admin_customer_email)
      about_minisite_email_path(@admin_customer_email.tracking)
    else
      '#'
    end
  end

  # customize about menu title text
  def navbar_brand_title
    t('.menus.brand.title', name: @studio.try(:name))
  end

  # customize about menu title text
  def navbar_brand_title
    t('.menus.brand.title', name: @studio.try(:name))
  end

  # minisite menu options for returning
  #   the link_path for this menu item
  def navbar_collection_path
    if @admin_customer_email
      index_custom_minisite_email_offers_path(@admin_customer_email.tracking)
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
      if @mock_collection
        '#'
      else
        if current_user_facebook
          facebook_signout_path
        else
          '/auth/facebook'
        end
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

  def navbar_photo_sessions_path
    #link_to_your_cart_or_not
    if @mock_collection == :return
      samples_my_studio_infos_path
    else
      if is_admin?
        admin_overview_path
      elsif is_studio?
        my_studio_sessions_path
      else
        '#'
      end

    end
  end

  def navbar_photo_sessions_name
    if @mock_collection == :return
      t(".menus.photo_sessions.mock.name")
    else
      t(".menus.photo_sessions.name")
    end
  end

  def navbar_photo_sessions_title
    if @mock_collection == :return
      t(".menus.photo_sessions.mock.title")
    else
      t(".menus.photo_sessions.title")
    end
  end

  def navbar_shopping_cart_path
    #link_to_your_cart_or_not
    @cart ? shopping_cart_path(@cart.tracking) : '#'
  end

  # customize the navbar name for shopping_cart
  def navbar_shopping_cart_name
    name = "#{icon_minisite("icon-shopping-cart")} #{t('.menus.shopping_cart.name')}"
    if @cart
      cart_numericality = content_tag(:span, id: :cart_numericality) do
        pluralize(@cart.try(:quantity), 'piece')
      end
      name              += " #{cart_numericality}"
    end
    name.html_safe
  end

  def navbar_suggestions_path
    if @admin_customer_email
      minisite_email_offers_path(@admin_customer_email.tracking)
    else
      '#'
    end

  end
end

