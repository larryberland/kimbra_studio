# Load the rails application
require File.expand_path('../application', __FILE__)

# Load custom config file for current environment
begin
  raw_config = File.read("config/config.yml")
  KIMBRA_STUDIO_CONFIG = YAML.load(raw_config)[Rails.env]
rescue  Exception => e
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
