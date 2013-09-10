require 'rubygems'
require 'bundler/setup'
require 'data_mapper'
require 'ostruct'

require 'sinatra' unless defined?(Sinatra)

configure do
  SiteConfig = OpenStruct.new(
    :title => 'OrgTop',
    :author => 'Eli James',
    :url_base => 'http://localhost:4567/'
  )

  set :environment, :production if settings.root == "/home/shadowsun7/webapps/orgtop/orgtop"
  settings_yaml = YAML.load_file(settings.root + "/config.yml")[settings.environment.to_s]
  settings_yaml.each_pair do |k, v|
    set(k.to_sym, v)
  end

  # load models
  $LOAD_PATH.unshift("#{File.dirname(__FILE__)}/lib")
  Dir.glob("#{File.dirname(__FILE__)}/lib/*.rb") { |lib| require File.basename(lib, '.*') }

  DataMapper.setup(:default, (ENV["DATABASE_URL"] || "mysql://#{settings.mysql_user}:#{settings.mysql_password}@localhost/shadowsun7_orgtop"))

  DataMapper.finalize
end
