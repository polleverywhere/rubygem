require 'bundler'
require 'rspec/core/rake_task'

# Tasks for our CI server
namespace :ci do
  desc "Run integration test against the API"
  task :build do
    Rake::Task["spec"].execute
  end
end

namespace :gem do
  Bundler::GemHelper.install_tasks
end

# Spec tasks
RSpec::Core::RakeTask.new