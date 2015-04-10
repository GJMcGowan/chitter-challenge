require 'sinatra/base'
require 'data_mapper'
require 'rack-flash'
require_relative 'data_mapper_setup'

class Chitter < Sinatra::Base

  set :views, proc { File.join(root, "..", "views") }

  helpers do
    def current_user
      @current_user ||= User.get(session[:user_id]) if session[:user_id]
    end
  end

  enable :sessions
  # use Rack::Flash

  get '/' do
    erb :index
  end

  post '/users/new' do
    user = User.create(name: params['Name'], email: params['Email'],
                       username: params['Username'])
    if user.save
      session[:user_id] = user.id
      @current_user = User.get(session[:user_id])
    end
    # else
    #   flash.now[:errors] = user.errors.full_messages
    # end
    erb :'users/new'
  end

  get '/users/all' do
    @users = User.all
    erb :'users/all'
  end

  # Hmm, perhaps it doesn't wipe the session properly
  # Definitely does not wipe it, username still visible
  def sign_out
    @current_user = nil
    session[:user_id] = nil
    redirect to('/')
  end
  # For html
  # <button type="button" onclick="<% sign_out %>">Log Out</button>
  # Inserting this html somehow breaks the whole website

  # start the server if ruby file executed directly
  run! if app_file == $PROGRAM_NAME

end
