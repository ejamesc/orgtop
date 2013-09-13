require File.join(File.dirname(__FILE__), 'application')

set :run, false
set :environment, :production

# it turns out that redirects STDOUT to a file makes Passenger explode
#FileUtils.mkdir_p 'log' unless File.exists?('log')
#log = File.new("log/sinatra.log", "a+")
#$stdout.reopen(log)
#$stderr.reopen(log)

run Sinatra::Application
