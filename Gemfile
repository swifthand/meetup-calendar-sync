source 'https://rubygems.org'

ruby "2.1.5"

gem 'rails', '4.1.10'

# Asset Gems
gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 2.5.0'
gem 'jquery-rails'

# Infrasutructure Gems
gem 'pg'
gem 'unicorn'

# External Service Gems
gem 'ruby_meetup2'
gem 'google-api-client', ">= 0.8.5"

group :development, :test do
  gem 'awesome_print'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'quiet_assets'
end

group :test do
  gem 'minitest-reporters'
  gem 'turn-again-reporter', '~> 1.0.1'
end

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end
