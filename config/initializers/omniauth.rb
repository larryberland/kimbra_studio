OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  permission_set = {scope: 'email,publish_stream'}
  if Rails.env.production?
    provider :facebook, ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_SECRET'], permission_set
  else
    provider :facebook, KIMBRA_STUDIO_CONFIG[:facebook][:app_id], KIMBRA_STUDIO_CONFIG[:facebook][:app_secret], permission_set
  end
end