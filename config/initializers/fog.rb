# info = YAML.load_file(Rails.root.join('config','amazon_s3.yml'))[Rails.env]

CarrierWave.configure do |config|
   config.fog_credentials = {
     :provider               => 'AWS',
     :aws_access_key_id      => KIMBRA_STUDIO_CONFIG[:s3]['access_key_id'],
     :aws_secret_access_key  => KIMBRA_STUDIO_CONFIG[:s3]['secret_access_key'],
   }
   config.fog_directory  = KIMBRA_STUDIO_CONFIG[:s3]['bucket_name']
   config.fog_public     = false
   config.fog_attributes = {}
   #config.fog_attributes = {'Cache-Control' => 'max-age=315576000'} # for static assets that can be cached by the browser for a long time.
end