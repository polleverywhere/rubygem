require 'rubygems'
require 'bundler/setup'
require 'rspec'
require 'polleverywhere'

PollEverywhere.config do
  username      "apitest"
  password      "apitest"
end
