source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.2'

gem 'rails', '7.0.7.1'
gem 'puma', '>= 6.3.1'
gem 'sass-rails'
gem 'turbolinks'
gem 'jbuilder'
gem 'jsbundling-rails', '>= 1.1.2'
gem 'stimulus-rails', '>= 1.2.2'
# Use Active Model has_secure_password
# gem 'bcrypt'

gem 'bootsnap', require: false

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails', '>= 6.0.3'
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', '>= 2.20.0', require: false
end

group :development do
  gem 'web-console'
  gem 'rack-mini-profiler'
  gem 'listen'
  gem 'spring'
end

group :test do
  gem 'simplecov', require: false
end
