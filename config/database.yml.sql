#   gem install mysql2
#
#   Ensure the mysql2 gem is defined in your Gemfile
#   gem 'mysql2'
#
default: &default
  adapter: mysql2
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  timeout: 5000
  options: PRAGMA foreign_keys=ON
  encoding: utf8
  reconnect: false
  username: root
  password: Locutores123

development:
  <<: *default
  database: development

# Warning: The database defined as "test" will be erased and
# re-generated from your development database when you run "rake".
# Do not set this db to the same as development or production.
test:
  <<: *default
  database: development_test

production:
  <<: *default
  database: development_production
