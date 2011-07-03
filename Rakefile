require 'bundler'
require 'rspec/core/rake_task'

api_dir = File.expand_path("./../api", __FILE__)

desc "Releases a RubyGem and API documentation"
task :release do
  Rake::Task["gem:release"].invoke
  Rake::Task["api:release"].invoke
end

# Deal with showing terminal commands in stdout. Ideally this is streamed, but 
# IO.popen is breaking because of Thor.
def cmd(cmd)
  puts cmd
  puts %x[#{cmd}]
  # IO.popen(cmd){ |f| puts f.gets }
end

# Build & release rubygem
namespace :gem do
  Bundler::GemHelper.install_tasks
end

# Build and release API documentation
namespace :api do
  desc "Publish API documentation to http://api.polleverywhere.com"
  task :publish do
    cmd %(rsync -ave "ssh -p 55555" #{api_dir}/build/ polleverywhere@proxy2.polleverywhere.net:~/api.polleverywhere.com/public)
  end

  desc "Builds the API docs to #{api_dir}/build"
  task :build do
    cmd %(cd #{api_dir} && bundle exec mm-build)
  end

  desc "Builds API docs and publishes them to http://api.polleverywhere.com"
  task :release do
    Rake::Task["api:build"].execute
    Rake::Task["api:publish"].execute
  end
end

# Tasks for our CI server
namespace :ci do
  desc "Run integration test against the API"
  task :build do
    Rake::Task["spec"].execute
  end
end

# Spec tasks
RSpec::Core::RakeTask.new