require 'rubygems'
require 'bundler/setup'
require 'rspec'
require 'polleverywhere'

PollEverywhere.config do
  username      "api_test"
  password      "api_test"
end