== README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

# Install and run Postgres

1. Update Homebrew’s package database: brew update
2. Install Postgres: brew install postgres
3. Finish creating the database: initdb /usr/local/var/postgres
4. Start running Postgres at login
  a) mkdir -p ~/Library/LaunchAgents
  b) ln -sfv /usr/local/opt/postgresql/*.plist ~/Library/LaunchAgents
  c) launchctl load ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist


# Manually start Postgres
pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start

# Manually stop Postgres
pg_ctl -D /usr/local/var/postgres stop -s -m fast

# Create user role in Postgres
createuser -s -r book_user

# Create the database
rake db:create

# Run database migrations
rake db:migrate
