class ClientMailer < ActionMailer::Base

  helper :application

  default from: "clickplus1@gmail.com"

  def send_offers(email)
    @email = email
    @client = email.my_studio_session.client
    @studio = email.my_studio_session.studio
    mail(:to =>  "#{@client.name} <#{@client.email}>",
         :subject => t(:client_send_offers_subject, :name => email.my_studio_session.studio.name))
  end

end