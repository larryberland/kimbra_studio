class DevelopmentMailInterceptor

  # in Development, intercept all emails and route them to me
  def self.delivering_email(message)
    puts "LDB: Intercept"
    if message.to.to_s.match(/studioone/)
      puts message.body.to_s
    end
    message.subject = "[#{message.to}] #{message.subject}"
    message.to = ["hokahey100@gmail.com", 'jim@jimjames.org']
  end

end