CarrierWave.configure do | config |  
  
  # Set the cache_dir as per instruction on below link.
  # https://github.com/jnicklas/carrierwave/wiki/How-to%3A-Make-Carrierwave-work-on-Heroku
  config.cache_dir = "#{Rails.root}/tmp/cache"

  # Config for Test Env.
  # Store the files locally for test environment
  if Rails.env.test?
    config.storage = :file
    config.enable_processing = false
    config.root = "#{Rails.root}/tmp"
  end
  
  # Config for Dev Env.
  if Rails.env.development?
    config.storage = :fog
    config.fog_credentials = {
      provider: "AWS",
      aws_access_key_id: CONFIG[:aws_access_key_id],
      aws_secret_access_key: CONFIG[:aws_access_key]
    }
    config.fog_directory = CONFIG[:aws_s3_bucket]
  else
  # Config for staging and production.
    config.storage = :fog 
    config.fog_credentials = {
      provider: "AWS",
      aws_access_key_id: CONFIG[:aws_access_key_id],
      aws_secret_access_key: CONFIG[:aws_access_key]
    }
    config.fog_directory = CONFIG[:aws_s3_bucket]
  end

end