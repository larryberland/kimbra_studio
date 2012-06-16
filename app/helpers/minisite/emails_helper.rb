module Minisite::EmailsHelper

  def status_for_cart(cart)
    if cart.shipping.tracking
      link_to "Shipped. UPS #{cart.shipping.tracking}.",
              "http://fuhry.us/packagestalker/track/ups/#{cart.shipping.tracking}",
              title: 'Click to track'
    else
      'Your order has not been shipped yet. We\'ll send a status email when it does.'
    end
  end

end