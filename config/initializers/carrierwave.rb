CarrierWave.configure do |config|
  config.remove_previously_stored_files_after_update = false
  # Configuration for Amazon S3
  config.fog_credentials = {
      :provider => 'AWS',
      :aws_access_key_id => Rails.application.credentials[Rails.env.to_sym][:aws][:access_key_id],
      :aws_secret_access_key => Rails.application.credentials[Rails.env.to_sym][:aws][:secret_access_key],
      :region => "eu-west-1",

  }

  #For testing, upload files to local `tmp` folder.
  if Rails.env.test? || Rails.env.development?
    config.storage = :file
    config.enable_processing = false
    #config.root = "#{Rails.root}/tmp"
  else
    config.storage = :fog
  end

  # To let CarrierWave work on heroku
  config.cache_dir = "#{Rails.root}/tmp/uploads"
  config.fog_directory = 'cefiles-prod'
  config.fog_attributes = {ssl_version: :TLSv1_2}
end