class DevelopmentMailInterceptor

  # in Development, intercept all emails and route them to me
  def self.delivering_email(message)
    puts "LDB: Intercept"
    message.subject = "[#{message.to}] #{message.subject}"
    message.to = "hokahey100@gmail.com"
  end

end