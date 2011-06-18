source "http://rubygems.org"

# Specify your gem's dependencies in polleverywhere.gemspec
gemspec

group :development, :test do
  gem 'rb-fsevent', :require => false if RUBY_PLATFORM =~ /darwin/i
  gem 'guard-rspec'
  gem 'growl'
  gem 'rspec'
  gem 'ruby-debug'
end