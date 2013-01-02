OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  app_id  = Rails.env.production? ? ENV['facebook_app_id'] : KIMBRA_STUDIO_CONFIG[:facebook][:app_id]
  secret  = Rails.env.production? ? ENV['facebook_app_secret'] : KIMBRA_STUDIO_CONFIG[:facebook][:app_secret]
  options = {scope:   'email,publish_stream'}
  provider :facebook, app_id, secret, options
end