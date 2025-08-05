source "https://rubygems.org"

gem "rails"
gem "propshaft"
gem "pg"
gem "puma"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "tailwindcss-rails"

gem "bcrypt"

gem "solid_cache"
gem "solid_queue"
gem "solid_cable"

gem "bootsnap", require: false

gem "image_processing"

group :development, :test do
  gem "brakeman", require: false
  gem "authentication-zero", require: false
end

group :test, :rubocop do
  gem "rubocop"
  gem "rubocop-migration"
  gem "rubocop-minitest"
  gem "rubocop-performance"
  gem "rubocop-rails_config"
end

group :development do
  gem "active_storage_dashboard"
  gem "web-console"
end
