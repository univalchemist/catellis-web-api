source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby '2.4.3'

gem 'rails', '~> 5.1.5'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Paranoia for soft-delete support
gem 'paranoia', '~> 2.2'

# Use Puma as the app server
gem 'puma', '~> 3.7'

# Environment variable and config loading
gem 'dotenv-rails', :require => 'dotenv/rails-now', :groups => [:development, :test]
gem 'global'

# GraphQL
gem 'graphql', '~> 1.7'

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors'

# Security
gem 'devise'
gem 'json_web_token'
gem 'rolify'
gem 'pundit'

# For service results
gem 'immutable-struct'
# Structs from nested hashes!
gem 'recursive-open-struct'

# FactoryBot and Fakey for sample data generation
gem 'factory_bot_rails', '~> 4.0'
gem 'faker', '~> 1.8'

# Twilio
gem 'twilio-ruby'

# Timezone support
gem 'timezone', '~> 1.0'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]

  # Model annotation (lists model properties in model header comment)
  # FIXME: this is not working properly....
  gem 'annotate'

  gem 'rspec-rails'
  gem 'guard'
  gem 'guard-rspec'
  gem "letter_opener"
  # Control network requests
  gem 'webmock'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'rb-readline'
  gem "graphiql-rails"
  gem 'pry'
end

group :test do
  gem 'database_cleaner'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
