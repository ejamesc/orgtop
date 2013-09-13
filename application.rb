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
  def admin?
    go_forth = request.cookies[settings.username] == settings.token
    puts go_forth
    go_forth
  end

  def protected!
    halt [ 401, 'Not authorized, you slimey curr!' ] unless admin?
  end
end

# root page
get '/' do
  erb :index
end

get '/login' do
  if admin? 
    redirect '/users'
  end
  erb :login
end

post '/login' do
  if params['username']==settings.username && params['password']==settings.password
    response.set_cookie(settings.username, settings.token) 
    redirect '/users'
  else
    "Username or Password incorrect. Again!"
  end
end

get '/logout' do
  response.set_cookie(settings.username, false) 
  redirect '/'
end

get '/users' do
  protected!
  @users = User.all(order: [ :name.asc ])
  erb :users
end

delete '/users/:id' do
  protected!
  @user = User.get(params[:id])
  @user.destroy
  redirect '/users', 303
end

post '/users/new' do
  protected!
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
  protected!
  @user = User.first(username: params[:username])

  if @user
    erb :users_edit
  else 
    halt 404, "User not found!"
  end
end

post '/users/edit/:username' do
  protected!
  user = User.first(username: params[:username])

  if user
    filtered_params = params.select { |k, v| %w[name username email role].include?(k) }
    user.update(filtered_params)
    redirect "/users", 303
  else 
    halt 404, "User not found!"
  end
end
