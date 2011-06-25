require 'rubygems'
require 'bundler/setup'
require 'rspec'
require 'polleverywhere'

PollEverywhere.config do
  username      "test"
  password      "test"
  # url           "http://localhost:3000"
  http_adapter  :sync
end