require 'bundler'
Bundler::GemHelper.install_tasks
require 'haml'
require 'polleverywhere'

namespace :doc do
  desc "Generate API documentation"
  task :api do
    puts PollEverywhere::API::Documentation.generate
  end
end