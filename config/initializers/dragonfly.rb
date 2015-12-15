require 'dragonfly'
require 'dragonfly/s3_data_store'

# Configure
Dragonfly.app.configure do
  plugin :imagemagick

  secret "06810258903414a2f5012d3bd6d702cae5231c7329ef00d916b4e42341fd71c3"

  url_format "/media/:job/:name"

  if Rails.env.production?
    datastore :s3,
      bucket_name: Figaro.env.aws_bucket_name,
      access_key_id: Figaro.env.aws_access_key_id,
      secret_access_key: Figaro.env.aws_secret_access_key,
      region: Figaro.env.aws_region
  else
    datastore :file,
      root_path: Rails.root.join('public/system/dragonfly', Rails.env),
      server_root: Rails.root.join('public')
  end
end

# Logger
Dragonfly.logger = Rails.logger

# Mount as middleware
Rails.application.middleware.use Dragonfly::Middleware

# Add model functionality
if defined?(ActiveRecord::Base)
  ActiveRecord::Base.extend Dragonfly::Model
  ActiveRecord::Base.extend Dragonfly::Model::Validations
end
