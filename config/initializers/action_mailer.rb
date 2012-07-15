if Rails.env.development?
  require 'development_mail_interceptor'
  ActionMailer::Base.register_interceptor(DevelopmentMailInterceptor)
end
KIMBRA_STUDIO_CONFIG[:mailer][:to_order_email] = ['jim@jimjames.org']
KIMBRA_STUDIO_CONFIG[:mailer][:to_order_email] << ',hokahey100@gmail.com'