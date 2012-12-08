OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  if Rails.env.production?
    provider :facebook, ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_SECRET']
  else
    provider :facebook, KIMBRA_STUDIO_CONFIG[:facebook][:app_id], KIMBRA_STUDIO_CONFIG[:facebook][:app_secret]
  end
end