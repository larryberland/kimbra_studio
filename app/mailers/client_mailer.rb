class ClientMailer < ActionMailer::Base

  helper :application

  default from: KIMBRA_STUDIO_CONFIG[:mailer][:support]

  def send_offers(email_id)
    @email = Admin::Customer::Email.find(email_id)
    @client = @email.my_studio_session.client
    @studio = @email.my_studio_session.studio
    logo = ''
    open('image.jpg', 'w') do |file|
      logo << open(@studio.minisite.image_url).read
    end
    attachments.inline['logo.png'] = logo
    mail(to: "#{@client.name} <#{@client.email}>",
         bcc: ['support@kimbraclickplus.com'],
         subject: 'Your recent photos in heirloom jewelry.',
         from: "#{@studio.name} <support@KimbraClickPLUS.com>")
    # Mark this email with the datetime sent.
    @email.update_attributes(:sent_at => Time.now.to_s(:db))
  end

  def send_order_confirmation(cart_id, studio_id)
    @cart = Shopping::Cart.find(cart_id)
    @studio = Studio.find(studio_id)
    @show_status_only = true
    mail(to: "#{@cart.address.first_name} #{@cart.address.last_name} <#{@cart.address.email}>",
         subject: "Photo Jewelry receipt from #{@studio.name} (Order number: #{@cart.tracking})",
         bcc: ['support@kimbraclickplus.com'],
         from: "#{@studio.name} <support@KimbraClickPLUS.com>")
  end

  def send_shipping_update(cart_id, studio_id)
    @cart = Shopping::Cart.find(cart_id)
    @studio = Studio.find(studio_id)
    @show_status_only = true
    mail(to: "#{@cart.address.first_name} #{@cart.address.last_name} <#{@cart.address.email}>",
         subject: "Your Photo Jewelry order has shipped. #{@studio.name}",
         bcc: ['support@kimbraclickplus.com'],
         from: "#{@studio.name} <support@KimbraClickPLUS.com>")
  end

  def send_offer_herald(session_id)
    @session = MyStudio::Session.find(session_id)
    @client = @session.client
    @studio = @session.studio
    logo = ''
    open('image.jpg', 'w') do |file|
      logo << open(@studio.minisite.image_url).read
    end
    attachments.inline['logo.png'] = logo
    sample = ''
    open('sample.jpg', 'w') do |file|
      sample << open(File.join(Rails.root, '/app/assets/images/kimbra_sample.jpg')).read
    end
    attachments.inline['sample.jpg'] = sample
    mail(to: "#{@client.name} <#{@client.email}>",
         subject: "Heirloom jewelry from your recent photo shoot with #{@studio.name}",
         bcc: ['support@kimbraclickplus.com'],
         from: "#{@studio.name} <support@KimbraClickPLUS.com>")
  end

end