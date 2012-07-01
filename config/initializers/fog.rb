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
   time_out = (5 * 24) * 60 * 60 # 5 days worth of seconds
   config.fog_attributes = {'Cache-Control' => "max-age=#{time_out}"} # for static assets that can be cached by the browser for a long time.
   config.cache_dir = "#{Rails.root}/tmp/uploads"
end