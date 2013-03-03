module BreadcrumbHelper

  def link_breadcrumb(menu, path)

    link_to(t(".#{menu}.link"), path, title: t(".#{menu}.title"))
  end

  # controllers before_filter#navbar_active
  #   sets the menu symbol that should be set with css_class active
  #
  # li_navbar_or_not(:menu_item) =>
  #
  #   for a model.new_record?
  #     <a title="View Delivery Details"
  #       href="/shopping/carts/hydh0yezkf/addresses/new#">
  #         Delivery Details
  #     </a>
  #   for a model edit record
  #     <a title="View Delivery Details"
  #       href="/shopping/carts/hydh0yezkf/addresses/22/edit">
  #         Delivery Details
  #     </a>
  def link_breadcrumb_or_not(menu)
    # path for the breadcrumb menu item
    path_method = "breadcrumb_#{menu}_path"
    path = send(path_method) if respond_to?(path_method.to_sym, include_private=true)
    path = '#' if path and current_page?(path) # if the current request is this path then stub it out with #
    path ||= '#'
    link_breadcrumb(menu, path)
  end

  private

  def breadcrumb_address_path
    if (@cart and @cart.address)
      unless @cart.address.new_record?
        edit_shopping_cart_address_path(@cart, @cart.address)
      end
    end
  end

  def breadcrumb_shipping_path
    if (@cart and @cart.shipping)
      unless @cart.shipping.new_record?
        edit_shopping_cart_shipping_path(@cart, @cart.shipping)
      end
    end
  end

end