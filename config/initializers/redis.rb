uri = ENV["REDISTOGO_URL"] || Figaro.env.redis_url
REDIS = Redis.new(:url => uri)