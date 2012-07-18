if Rails.env.development?
  require 'development_mail_interceptor'
  ActionMailer::Base.register_interceptor(DevelopmentMailInterceptor)
end
KIMBRA_STUDIO_CONFIG[:mailer][:kimbra_order] = ['jim@jimjames.org']
KIMBRA_STUDIO_CONFIG[:mailer][:kimbra_order] << ',hokahey100@gmail.com'

KIMBRA_STUDIO_CONFIG[:mailer][:support] = "Support <support@KimbraClickPLUS.com>"
KIMBRA_STUDIO_CONFIG[:mailer][:sales]   = "Sales <sales@KimbraClickPLUS.com>"
