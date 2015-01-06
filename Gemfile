source 'https://rubygems.org'
ruby '2.1.2'
#ruby-gemset=da-slideshow

gem 'rails', '4.1.8'
gem 'bcrypt-ruby', '3.1.2'
gem 'faker', '1.4.3'
gem 'haml-rails'
gem 'sass-rails', '4.0.3'
gem 'uglifier', '2.1.1'
gem 'coffee-rails', '4.0.1'
gem 'jquery-rails', '3.0.4'
gem 'turbolinks', '1.1.1'
gem 'jbuilder', '1.0.2'
gem 'sprockets', '2.11.0'
gem 'puma'
gem 'redis', '3.0.6'
gem 'sidekiq'
gem 'sidetiq'


group :production do
	gem 'mysql'
end

group :development, :test do
  gem 'sqlite3', '1.3.8'
  gem 'rspec-rails'
  gem 'guard-rspec'
  gem 'spork-rails'
  gem 'guard-spork'
  gem 'childprocess'
  gem 'did_you_mean'
end

group :test do
  gem 'selenium-webdriver', '2.35.1'
  gem 'capybara', '2.2.0'
  gem 'factory_girl_rails', '4.2.0'
end

group :doc do
  gem 'sdoc', '0.3.20', require: false
end
