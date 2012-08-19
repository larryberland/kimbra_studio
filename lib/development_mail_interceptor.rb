class DevelopmentMailInterceptor

  # in Development, intercept all emails and route them to me
  def self.delivering_email(message)
    message.subject = "[#{message.to}] #{message.subject}"
    if `hostname`.match(/james|chapterhouse/i)
      message.to = ['jim@jimjames.org']
    else
      message.to = ['hokahey100@gmail.com']
    end
    puts "Sending email to #{message.to}"
  end

end