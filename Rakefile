require 'bundler'
Bundler::GemHelper.install_tasks
require 'polleverywhere'

namespace :doc do
  desc "Generate API documentation"
  task :api do
    PollEverywhere.config do
      username      "test"
      password      "test"
      url           "http://api.polleverywhere.com"
      http_adapter  :doc
    end

    puts PollEverywhere::API::Documentation.generate
  end
end