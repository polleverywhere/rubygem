require 'bundler'
Bundler::GemHelper.install_tasks
require 'haml'
require 'polleverywhere'

namespace :doc do
  desc "Generate API documentation"
  task :api do
    PollEverywhere.config do
      username "test"
      password "test"
    end

    puts PollEverywhere::API::Documentation.generate
  end
end