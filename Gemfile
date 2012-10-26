
source 'https://rubygems.org'

gem 'rails', '3.2.3'
gem 'aws-s3', :require => 'aws/s3'

group :production do
	#gem 'pg', '0.12.2'
	gem 'thin'
end

group :development do
	gem 'annotate', '~> 2.4.1.beta'
	gem 'sqlite3'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', '~> 3.2.3'
  gem 'compass'
  gem 'coffee-rails', '~> 3.2.1'
  # gem 'jquery-ui-rails'
  gem 'compass-rails', '~> 1.0.3'
  gem 'zurb-foundation', '~> 3.0.9'
  gem 'uglifier', '>= 1.2.3'
end
gem 'jquery-rails'

# To use ActiveModel has_secure_password
gem 'bcrypt-ruby', '~> 3.0.0'
gem 'simple_form'

# gem 'rmagick'
gem 'carrierwave'