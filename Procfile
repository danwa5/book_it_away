web: bundle exec rails server -p $PORT
worker: bundle exec sidekiq -i 0 -c 5 -q default -C config/sidekiq.yml -v
