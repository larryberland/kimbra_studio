class MailObserver

  def self.delivered_email(message)
    # Create a SentEmail for every email that goes out.
    # This creates one place we can go to check we are not spamming a consumer with too many emails.
    # Email addresses look like 'jim@james.org'' or 'Jim James <jim@james.org>' - we want the jim@james.org part.
    message.to.each do |address|
      if address.to_s.match(/<.*>/)
        email = $~.to_s.gsub(/[<>]/, '')
      else
        email = address.to_s
      end
      SentEmail.create(email: email, subject: message.subject)
    end
  end

end