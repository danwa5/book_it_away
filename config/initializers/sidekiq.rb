redis_opts = { :url => (ENV["REDISTOGO_URL"] || Figaro.env.redis_url), namespace: 'book_it_away' }

Sidekiq.configure_server do |config|
  config.redis = redis_opts
end

Sidekiq.configure_client do |config|
  config.redis = redis_opts
end
