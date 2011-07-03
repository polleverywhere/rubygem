require 'rubygems'
require 'bundler/setup'
require 'rspec'
require 'polleverywhere'

PollEverywhere.config do
  username      "test"
  password      "test"
end