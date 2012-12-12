OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  app_id  = Rails.env.production? ? ENV['FACEBOOK_APP_ID'] : KIMBRA_STUDIO_CONFIG[:facebook][:app_id]
  secret  = Rails.env.production? ? ENV['FACEBOOK_SECRET'] : KIMBRA_STUDIO_CONFIG[:facebook][:app_secret]
  options = {scope:   'email,publish_stream'}
  provider :facebook, app_id, secret, options
end