# Load the rails application
require File.expand_path('../application', __FILE__)

# Load custom config file for current environment
begin
  # Base config values common to all environments.
  KIMBRA_STUDIO_CONFIG = YAML.load_file('config/kimbra_studio.yml')[Rails.env]

  if Rails.env == 'production'
    # Load these from heroku ENV vars. Run xxx ruby script to load heroku with any updates to sensitive.yml.
    KIMBRA_STUDIO_CONFIG.each do |top_level_key, top_level_value_hash|
      # Skip keys whose values are not hashes. We want things like :s3=>{:username=>'abc',:pw=>'123'}
      if top_level_value_hash.is_a? Hash
        top_level_value_hash.each do |k, v|
          heroku_env_key = "#{top_level_key}_#{k}"
          if ENV[heroku_env_key]
            KIMBRA_STUDIO_CONFIG[top_level_key][k] = ENV[heroku_env_key]
          end
        end
      else
      end
    end
  else
    # Uses local sensitive.yml file - get a copy from Larry or Jim.
    sensitive = YAML.load_file('config/sensitive.yml')[Rails.env]
    sensitive.each do |k, v|
      KIMBRA_STUDIO_CONFIG[k].merge!(v)
    end
  end
rescue Exception => e
  puts "#{ e } (#{ e.class })!"
  raise "
  ############################################################################################
  ############################################################################################
    You need to setup the config.yml
    copy config.yml.example to config.yml

    Make sure you personalize the passwords in this file and for security never check this file in.
  ############################################################################################
  ############################################################################################
  "
end

# Initialize the rails application
KimbraStudio::Application.initialize!