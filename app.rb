require "sinatra"
require "active_record"
require "./lib/database_connection"
require "rack-flash"

class App < Sinatra::Application
  enable :sessions
  use Rack::Flash

  def initialize
    super
    @database_connection = DatabaseConnection.new(ENV["RACK_ENV"])
  end

  get "/" do
    if session[:user_id]
      current_user = @database_connection.sql("Select * FROM users where id = #{session[:user_id]}").first
      users = @database_connection.sql("SELECT username from users where id != #{session[:user_id]}")
      erb :logged_in, locals: {:users => users, :current_user => current_user}
    else
      erb :root
    end
  end

  get "/register" do
    erb :register
  end

  post "/register" do
    if params[:username] == ""
      flash.now[:notice] = "Username cannot be blank"
      erb :register
    elsif params[:password] == ""
      flash.now[:notice] = "Password cannot be blank"
      erb :register
    elsif register_user_exists?(params[:username])
      flash.now[:notice] = "Username already exists"
      erb :register
    else
      @database_connection.sql("INSERT INTO users (username, password) values ('#{params[:username]}','#{params[:password]}')")
      flash[:notice] = "Thank you for registering"
      redirect '/'
    end
  end

  post "/login" do
    id_array = @database_connection.sql("SELECT id FROM users WHERE username ='#{params[:username]}' and password = '#{params[:password]}'")
    id_hash = id_array.first
    id = id_hash["id"]
    session[:user_id] = id
    redirect '/'
  end

  get "/sort" do
    users = @database_connection.sql("SELECT username from users where id != #{session[:user_id]} by username")
    erb :sort, locals: {:users => users}
  end



  get "/logout" do
    session.clear
    redirect '/'
  end

  private

  def register_user_exists?(username)
    id_array = @database_connection.sql("SELECT id FROM users WHERE username ='#{username}'")
    if id_array
    end
  end

end