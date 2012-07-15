class KimbraMailer < ActionMailer::Base

  helper :application

  default from: "Sales KimbraClickPlus <sales@KimbraClickPLUS.com>"
  default to: KIMBRA_STUDIO_CONFIG[:mailer][:to_order_email]

  def send_order(email_id)
    @email = Admin::Customer::Email.find(email_id)
    @client = @email.my_studio_session.client
    @studio = @email.my_studio_session.studio
    logo = ''
    open('image.jpg', 'w') do |file|
      logo << open(@studio.minisite.image_url).read
    end
    attachments.inline['logo.png'] = logo
    mail(bcc: ['jim@jimjames.org'],
         subject: 'Another Order from KimbraClickPLUS.')
  end

end