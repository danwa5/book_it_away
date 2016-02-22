web: bundle exec rails server -p $PORT
redis: redis-server /usr/local/etc/redis.conf
worker: bundle exec sidekiq -i 0 -c 5 -q default -C config/sidekiq.yml -v