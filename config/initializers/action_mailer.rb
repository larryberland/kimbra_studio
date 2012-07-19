if Rails.env.development?
  require 'development_mail_interceptor'
  ActionMailer::Base.register_interceptor(DevelopmentMailInterceptor)
end

require 'mail_observer'
ActionMailer::Base.register_observer(MailObserver)

KIMBRA_STUDIO_CONFIG[:mailer][:kimbra_order] = ['jim@jimjames.org']
KIMBRA_STUDIO_CONFIG[:mailer][:kimbra_order] << ',hokahey100@gmail.com'

KIMBRA_STUDIO_CONFIG[:mailer][:support] = "Kimbra ClickPLUS Support <support@KimbraClickPLUS.com>"
KIMBRA_STUDIO_CONFIG[:mailer][:sales]   = "Kimbra ClickPLUS Sales <sales@KimbraClickPLUS.com>"