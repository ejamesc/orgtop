require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'pony'
require File.join(File.dirname(__FILE__), 'environment')

# enable .html.erb templates
Tilt.register Tilt::ERBTemplate, 'html.erb'

configure do
  set :views, "#{File.dirname(__FILE__)}/views"
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

get '/users' do
  @users = User.all(order: [ :name.asc ])
  erb :users
end

post '/users/new' do
  user = User.create(name: params[:name],
              username: params[:username],
              email: params[:email],
              role: params[:role])
  if !user # problematic
    erb "ERROR"
  else
    redirect "/users", 303
  end
  redirect "/users", 303
end

