source "https://rubygems.org"

# Specify your gem's dependencies in polleverywhere.gemspec
gemspec

group :development, :test do
  gem 'rb-fsevent', :require => false if RUBY_PLATFORM =~ /darwin/i
  gem 'rake'
end

group :test do
  gem 'rspec', '~> 3'
end

group :development do
  gem 'guard-rspec'
  gem 'listen', '~> 2'
end
