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
    halt 500, "User create error!"
  end
  redirect "/users", 303
end

get '/users/edit/:username' do
  @user = User.first(username: params[:username])

  if @user
    erb :users_edit
  else 
    halt 404, "User not found!"
  end
end

post '/users/edit/:username' do
  user = User.first(username: params[:username])

  if user
    filtered_params = params.select { |k, v| %w[name username email role].include?(k) }
    user.update(filtered_params)
    redirect "/users", 303
  else 
    halt 404, "User not found!"
  end
end
