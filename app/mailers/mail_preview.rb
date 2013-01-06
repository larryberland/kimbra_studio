class MailPreview < MailView

  # NOTE -- need to restart the server to see changes here.

  def reset_password_instructions
    user = User.first
    Devise::Mailer.reset_password_instructions(user)
  end

  def send_offers
    # This will use the most recent offer email you constructed.
    email = Admin::Customer::Email.last
    offer = email.offers.first
    ClientMailer.send_offers(email.id, offer.id)
  end

  def send_build_offers
    # This will use the most recent offer email you constructed.
    email = Admin::Customer::Email.find_by_tracking('n7kdadxjzh')
    ClientMailer.send_build_offers(email.id, view_only=true)
  end

  def send_offer_herald
    # This will use the most recent session you constructed.
    session = MyStudio::Session.last
    ClientMailer.send_offer_herald(session.id)
  end

  def send_order_confirmation
    # This will use the most recent cart with a purchase.
    cart = Shopping::Cart.includes(:purchase).where('shopping_purchases.total is not null').last
    studio = cart.email.my_studio_session.studio
    ClientMailer.send_order_confirmation(cart.id, studio.id)
  end

  def send_shipping_update
    # This will use the most recent cart.
    cart = Shopping::Cart.last
    studio = cart.email.my_studio_session.studio
    ClientMailer.send_shipping_update(cart.id, studio.id)
  end

  def signup_notification
    studio = MyStudio::Minisite.where('image is not null').last.studio
    Notifier.signup_notification(studio.id)
  end

  def session_ready
    # Most recent session.
    session = MyStudio::Session.last
    Notifier.session_ready(session.id)
  end

  def studio_eap_email
    # Most recent studio with a logo.
    studio = MyStudio::Minisite.where('image is not null').last.studio
    Notifier.studio_eap_email(studio.id)
  end

  def studio_tkg_email
    # Most recent studio with a logo.
    studio = MyStudio::Minisite.where('image is not null').last.studio
    Notifier.studio_tkg_email(studio.id)
  end

  def studio_xms_email
    # Most recent studio with a logo.
    studio = MyStudio::Minisite.where('image is not null').last.studio
    Notifier.studio_xms_email(studio.id)
  end

  def studio_pinterest
    # Most recent studio with a logo.
    studio = MyStudio::Minisite.where('image is not null').last.studio
    Notifier.studio_pinterest(studio.id)
  end

end