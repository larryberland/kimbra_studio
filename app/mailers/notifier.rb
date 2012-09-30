class Notifier < ActionMailer::Base

  default from: "Kimbra Support <support@KimbraClickPLUS.com>"

  def signup_notification(studio_id)
    recipient = Studio.find(studio_id)
    mail(to: recipient.email_address_with_name,
         subject: "New account information") do |format|
      format.text { render :text => "Welcome!  #{recipient.name} go to #{my_studio_activation_url(recipient.owner.perishable_token)}" }
      format.html { render :text => "<h1>Welcome</h1> #{recipient.name} <a href='#{my_studio_activation_url(recipient.owner.perishable_token)}'>Click to Activate</a>" }
    end
  end

  def studio_signup_confirmation(studio_id, password)
    @studio = Studio.find(studio_id)
    @password = password
    @name = @studio.owner.name
    @email = @studio.owner.email
    studio_logo = ''
    open('studio_logo.jpg', 'w') do |file|
      studio_logo << open(@studio.minisite.image_url).read
    end
    attachments.inline['logo.png'] = studio_logo
    kimbra_logo = ''
    open('kimbra_logo.png', 'w') do |file|
      kimbra_logo << open(File.join(Rails.root, '/app/assets/images/kimbra_logo.png')).read
    end
    attachments.inline['kimbra_logo.png'] = kimbra_logo
    mail(to: email,
         subject: "New KimbraClickPLUS program - welcome to #{@studio.name}",
         bcc: 'support@KimbraClickPLUS.com')
  end

end