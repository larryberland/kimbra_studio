class Notifier < ActionMailer::Base

  default from: "Kimbra Support <support@KimbraClickPLUS.com>"

  def signup_notification(studio_id)
    puts "HOORAY WE ARE IN SIGNUP_NOTIFICATION"
    recipient = Studio.find(studio_id)
    mail(:to => recipient.email_address_with_name,
         :subject => "New account information") do |format|
      format.text { render :text => "Welcome!  #{recipient.name} go to #{my_studio_activation_url(recipient.owner.perishable_token )}" }
      format.html { render :text => "<h1>Welcome</h1> #{recipient.name} <a href='#{my_studio_activation_url(recipient.owner.perishable_token )}'>Click to Activate</a>" }
    end
  end

end