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

gem "access-granted"

# gem "lexxy", "~> 0.1.4.beta"

gem "mailgun-ruby"

group :development, :test do
  gem "active_storage_dashboard"
  # gem "hotwire-spark"
  gem "brakeman", require: false
end

group :test, :rubocop do
  gem "rubocop"
  gem "rubocop-migration"
  gem "rubocop-minitest"
  gem "rubocop-performance"
  gem "rubocop-rails_config"
end

group :development do
  gem "dotenv"
  gem "web-console"
  gem "dockerfile-rails", require: false
end
