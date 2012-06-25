
mailer_config                    = {
    :address              => KIMBRA_STUDIO_CONFIG[:mailer][:address],
    :port                 => KIMBRA_STUDIO_CONFIG[:mailer][:port],
    :domain               => KIMBRA_STUDIO_CONFIG[:mailer][:domain],
    :user_name            => KIMBRA_STUDIO_CONFIG[:mailer][:user_name],
    :password             => KIMBRA_STUDIO_CONFIG[:mailer][:password],
    :authentication       => KIMBRA_STUDIO_CONFIG[:mailer][:authentication],
    :enable_starttls_auto => true}
ActionMailer::Base.smtp_settings = mailer_config

ActionMailer::Base.default_url_options = KIMBRA_STUDIO_CONFIG[:mailer][:default_url_options]
#puts "mailer_default_url_options =>#{ActionMailer::Base.default_url_options.inspect}"

# LDB:: remove for when ready for real production
unless Rails.env.test?
  require 'development_mail_interceptor'
  ActionMailer::Base.register_interceptor(DevelopmentMailInterceptor)
end
