require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'pony'
require File.join(File.dirname(__FILE__), 'environment')

configure do
  set :views, "#{File.dirname(__FILE__)}/views"

  settings_yaml = YAML.load_file(settings.root + "/config.yml")[settings.environment.to_s]
  settings_yaml.each_pair do |k, v|
    set(k.to_sym, v)
  end
end

error do
  e = request.env['sinatra.error']
  Kernel.puts e.backtrace.join("\n")
  'Application error'
end

helpers do
  # add your helpers here
end

# root page
get '/' do
  erb :index
end

