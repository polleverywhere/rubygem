require 'bundler'
Bundler::GemHelper.install_tasks
require 'polleverywhere'

api_dir = File.expand_path("./../api", __FILE__)

# Deal with showing terminal commands in stdout. Ideally this is streamed, but IO.popen is breaking because of Thor.
def cmd(cmd)
  puts cmd
  puts %x[#{cmd}]
  # IO.popen(cmd){ |f| puts f.gets }
end

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