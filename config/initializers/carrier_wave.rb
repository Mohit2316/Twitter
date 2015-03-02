if Rails.env.production?
  CarrierWave.configure do |config|
    config.fog_credentials = {
        # Configuration for Amazon S3
        :provider              => 'AWS',
        :aws_access_key_id     => ENV['AKIAJ4FMBB3RVNI4ILPQ'],
        :aws_secret_access_key => ENV['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']
    }
    config.fog_directory     =  ENV['finhub']
  end
end