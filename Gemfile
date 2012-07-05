source 'http://rubygems.org'

ruby '1.9.3'
gem 'rails', '3.2.6'
gem 'thin'

gem 'rmagick'
gem 'carrierwave'
gem 'devise'
gem 'pg'

gem 'blueprint-rails'
gem 'web-app-theme', :git =>'git://github.com/pilu/web-app-theme.git'
gem 'rest-client'
gem 'crack'

gem 'inherited_resources'
gem 'aws-s3', :require => 'aws/s3'
gem 'fog'
gem 'jcrop-rails'
gem 'dalli'

gem 'friendly_id'
gem 'state_machine', '~> 1.1'

gem 'stripe'

gem "useragent", :git => "https://github.com/jilion/useragent.git"
gem 'haml'

gem 'jquery-rails'
gem 'client_side_validations'

gem 'delayed_job_active_record'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'coffee-rails'
  gem 'uglifier'
  gem 'jquery-ui-rails'
  gem 'sass-rails'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'  # replaces fixtures
end

group :test do
  gem 'faker'
  gem 'capybara'      # simulate user awesome gem
  gem 'guard-rspec'   # auto-run spec after save
  gem 'database_cleaner'
  # Pretty printed test output
  gem 'turn', '0.8.2', :require => false
end
