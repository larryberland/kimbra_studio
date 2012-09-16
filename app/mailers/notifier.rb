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

  def studio_signup_confirmation(studio_id, name, email, password)
    @password = password
    @name = name
    @email = email
    @studio = Studio.find(studio_id)
    logo = ''
        open('image.jpg', 'w') do |file|
          logo << open(File.join(Rails.root, '/app/assets/images/kimbra_logo.png')).read
        end
        attachments.inline['logo.png'] = logo
    mail(to: email,
         subject: "New KimbraClickPLUS account",
         bcc: 'support@KimbraClickPLUS.com')
  end

end