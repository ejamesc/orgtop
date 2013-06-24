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

# refactor
post '/send-email' do
  send_email('ejames@nushackers.org')
  puts "Success"
end

def send_email(email_add)
  Pony.mail({
    :to => email_add,
    :subject => "[orgtop] Hello World",
    :body => "Hello there, this is orgtop speaking.",
    :via => :smtp,
    :via_options => {
      :address              => 'smtp.gmail.com',
      :port                 => '587',
      :enable_starttls_auto => true,
      :user_name            => settings.gmail_email,
      :password             => settings.gmail_password,
      :authentication       => :plain, 
      :domain               => "localhost.localdomain", # the HELO domain provided by the client to the server
    }
  })
end
