source "http://rubygems.org"

# Specify your gem's dependencies in polleverywhere.gemspec
gemspec

group :development, :test do
  gem 'guard-rspec'
  gem 'rb-fsevent', :require => false if RUBY_PLATFORM =~ /darwin/i
  gem 'growl'
  gem 'rspec'
  gem 'ruby-debug19'
end

group :api_docs do
  gem 'middleman'
end