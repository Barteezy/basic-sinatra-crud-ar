require "sinatra"
require "active_record"
require "./lib/database_connection"
require "rack-flash"

class App < Sinatra::Application
  enable :sessions
  use Rack::Flash

  def initialize
    super
    @database_connection = DatabaseConnection.establish(ENV["RACK_ENV"])
  end

  get "/" do
    if session[:user_id]
      current_user = @database_connection.sql("Select * FROM users where id = #{session[:user_id]}").first
      users = @database_connection.sql("SELECT username from users where id != #{session[:user_id]}")
      fish = @database_connection.sql("SELECT * from fish where user_id = '#{session[:user_id]}'")
      p fish
      p "--------------------------------------------------------------------------------------------------- "
      erb :logged_in, locals: {:users => users, :current_user => current_user, :fishes => fish}
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
    if params[:ascending] == "on"
      users = @database_connection.sql("SELECT username from users where id <> #{session[:user_id]} order by username")
    else
      params[:descending] == "on"
      users = @database_connection.sql("SELECT username from users where id <> #{session[:user_id]} order by username DESC")
    end
    erb :sort, locals: {:users => users}
  end

  post "/" do
    @database_connection.sql("Delete From users where username = '#{params[:username]}'")
    redirect "/"
  end


  get "/logout" do
    session.clear
    redirect '/'
  end

  get "/add_fish" do
    erb :add_fish
  end

  post "/add_fish" do
    @database_connection.sql("INSERT INTO fish (fish_name, wiki_page, pic, user_id) values ('#{params[:fish_name]}','#{params[:wiki_page]}','#{params[:pic]}','#{session[:user_id]}')")
    redirect "/"
  end

  private

  def register_user_exists?(username)
    id_array = @database_connection.sql("SELECT id FROM users WHERE username ='#{username}'")
    if id_array
    end
  end

end
