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

  def studio_eap_email(studio_id)
    @studio = Studio.find(studio_id)
    @password = @studio.owner.first_pass
    @name = @studio.owner.name
    @email = @studio.owner.email
    raise "this email already unsubscribed: #{@email}" if Unsubscribe.exists?(email: @email)
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
    mail(to: @email,
         subject: "New KimbraClickPLUS program - welcome to #{@studio.name} (EAP)",
         bcc: 'support@KimbraClickPLUS.com')
  end

  def session_ready(session_id)
    sess = MyStudio::Session.find(session_id)
    mail(to: 'admin@kimbraclickplus.com',
         subject: "Session ready: #{sess.studio.name}") do |format|
      format.html { render :text => "<h1>#{sess.studio.name}</h1> <a href='#{admin_overview_url}'>Session portraits are ready for email generation and offer processing.</a>" }
    end
  end

  def studio_tkg_email(studio_id)
    @studio = Studio.find(studio_id)
    @password = @studio.owner.first_pass
    @name = @studio.owner.name
    @email = @studio.owner.email
    raise "this email already unsubscribed: #{@email}" if Unsubscribe.exists?(email: @email)
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
    mail(to: @email,
         subject: "New KimbraClickPLUS program - Thanksgiving (TKG)",
         bcc: 'support@KimbraClickPLUS.com')
  end

end