Mail.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?
KIMBRA_STUDIO_CONFIG[:mailer][:kimbra_studio][:to_order_email] = ['jim@jimjames.org']
KIMBRA_STUDIO_CONFIG[:mailer][:kimbra_studio][:to_order_email] << ',hokahey100@gmail.com'