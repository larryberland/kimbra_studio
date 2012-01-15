class Notifier < ActionMailer::Base
  # default :from => # should be set in initializer/action_mailer "Kathy Perry Originals <kathyperry1000@gmail.com>"

  # Simple Welcome mailer
  # => CUSTOMIZE FOR YOUR OWN APP
  #
  # @param [user] user that signed up
  # => user must respond to email_address_with_name and name
  def signup_notification(recipient)
    @account = recipient

    #attachments['an-image.jp'] = File.read("an-image.jpg")
    #attachments['terms.pdf'] = {:content => generate_your_pdf_here() }

    mail(:to => recipient.email_address_with_name,
         :subject => "New account information") do |format|
      format.text { render :text => "Welcome!  #{recipient.name} go to #{my_studio_activation_url(recipient.owner.perishable_token )}" }
      format.html { render :text => "<h1>Welcome</h1> #{recipient.name} <a href='#{my_studio_activation_url(recipient.owner.perishable_token )}'>Click to Activate</a>" }
    end

  end

end
