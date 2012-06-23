class ClientMailer < ActionMailer::Base

  helper :application

  default from: "clickplus1@gmail.com"

  def send_offers(email)
    @email = email
    @client = email.my_studio_session.client
    @studio = email.my_studio_session.studio
    attachments.inline['logo.png'] = File.read("public/studios/studio_one/minisite/studiog_logo.png")
# TODO - fix this path...
#   attachments.inline['logo.png'] = File.read(@studio.minisite.logo_url)
    mail(to: "#{@client.name} <#{@client.email}>",
         subject: t(:client_send_offers_subject, :name => @studio.name))
  end

  def send_order_confirmation(cart, studio)
    @cart = cart
    @studio = studio
    @show_status_only = true
    mail(to: "#{cart.address.first_name} #{cart.address.first_name} <#{cart.address.email}>",
         subject: "Photo Jewelry order from #{studio.name}",
         #TODO Change this to use service address at Kimbra CLICK+
         bcc: 'jim@jimjames.org')
  end

  def send_shipping_update(cart, studio)
    @cart = cart
    @studio = studio
    @show_status_only = true
    mail(to: "#{cart.address.first_name} #{cart.address.first_name} <#{cart.address.email}>",
         subject: "Your Photo Jewelry order from #{studio.name} has shipped.",
         #TODO Change this to use service address at Kimbra CLICK+
         bcc: 'jim@jimjames.org')
  end

end