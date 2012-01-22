info = YAML.load_file(Rails.root.join('config','amazon_s3.yml'))[Rails.env]

CarrierWave.configure do |config|
   config.fog_credentials = {
     :provider               => 'AWS',
     :aws_access_key_id      => info['access_key_id'],
     :aws_secret_access_key  => info['secret_access_key'],
   }
   config.fog_directory  = info['bucket_name']
   config.fog_public     = false
   #config.fog_attributes = {'Cache-Control' => 'max-age=315576000'}

end
