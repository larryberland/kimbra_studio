class KimbraMailer < ActionMailer::Base

  helper :application

  default from: KIMBRA_STUDIO_CONFIG[:mailer][:sales]
  default to: KIMBRA_STUDIO_CONFIG[:mailer][:kimbra_order]

  def send_order(cart_id, studio_id)
    @cart   = Shopping::Cart.find(cart_id)
    @studio = Studio.find(studio_id)

    logo = ''
    open('image.jpg', 'w') do |file|
      logo << open(@studio.minisite.image_url).read
    end
    attachments.inline['logo.png'] = logo
    mail(bcc:     ['jim@jimjames.org'],
         subject: 'Another Order from KimbraClickPLUS.')
  end

end