require 'rubygems'
require 'bundler/setup'
require 'middleman'
require 'polleverywhere'
require 'sourcify'

PollEverywhere.config do
  username      "test"
  password      "test"
  url           "http://localhost:3000"
  http_adapter  :doc
end

run Middleman::Server