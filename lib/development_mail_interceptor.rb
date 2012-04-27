class DevelopmentMailInterceptor

  # in Development, intercept all emails and route them to me
  def self.delivering_email(message)
    puts "LDB: Intercept"
    if message.to.to_s.match(/studioone/)
      puts message.body.to_s
    end
    message.subject = "[#{message.to}] #{message.subject}"
    if `hostname`.match(/james|chapterhouse/i)
      message.to = ['jjames@clarityservices.com']
    else
      message.to = ["hokahey100@gmail.com"]
    end
    puts "Sending email to #{message.to}"
  end

end