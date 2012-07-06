class ClientMailer < ActionMailer::Base

  helper :application

  default from: "support@KimbraClickPLUS.com"

  def send_offers(email_id)
    @email = Admin::Customer::Email.find(email_id)
    @client = @email.my_studio_session.client
    @studio = @email.my_studio_session.studio
    attachments.inline['logo.png'] = File.read("public/studios/studio_one/minisite/studiog_logo.png")
# TODO - fix this path...
#   attachments.inline['logo.png'] = File.read(@studio.minisite.logo_url)
    mail(to: "#{@client.name} <#{@client.email}>",
         subject: t(:client_send_offers_subject, :name => @studio.name))
  end

  def send_order_confirmation(cart_id, studio_id)
    @cart = Shopping::Cart.find(cart_id)
    @studio = Studio.find.(studio_id)
    @show_status_only = true
    mail(to: "#{@cart.address.first_name} #{@cart.address.last_name} <#{@cart.address.email}>",
         subject: "Photo Jewelry order from #{@studio.name}",
         bcc: ['support@kimbraclickplus.com','jim@jimjames.org'])
  end

  def send_shipping_update(cart_id, studio_id)
    @cart = Shopping::Cart.find(cart_id)
    @studio = Studio.find(studio_id)
    @show_status_only = true
    mail(to: "#{@cart.address.first_name} #{@cart.address.last_name} <#{@cart.address.email}>",
         subject: "Your Photo Jewelry order from #{@studio.name} has shipped.",
         bcc: ['support@kimbraclickplus.com','jim@jimjames.org'])
  end

end