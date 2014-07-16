require "sinatra"
require "active_record"
require "rack-flash"
require "gschool_database_connection"

class App < Sinatra::Application
  enable :sessions
  use Rack::Flash

  def initialize
    super
    @database_connection = GschoolDatabaseConnection::DatabaseConnection.establish(ENV["RACK_ENV"])
  end

  get "/" do
    if session[:user_id]
      current_user = @database_connection.sql("select username from users where id = #{session[:user_id]}").first
      other_users = @database_connection.sql("select username from users where id != #{session[:user_id]}")
      users_fish = @database_connection.sql("select * from fish where user_id = '#{session[:user_id]}'")
      fav_fish = favorite_fish
      erb :logged_in, locals: {:current_user => current_user, :other_users => other_users, :users_fish => users_fish, :fav_fish => fav_fish}
    else
      erb :index
    end
  end

  get "/register" do
    erb :register
  end

  post "/register" do
    if params[:username] == ""
      flash.now[:notice] = "username cannot be blank"
      erb :register
    elsif params[:password] == ""
      flash.now[:notice] = "password cannot be blank"
      erb :register
    elsif @database_connection.sql("select * from users where username = '#{params[:username]}'") != []
      flash.now[:notice] = "username already taken"
      erb :register
    else
      @database_connection.sql("insert into users(username, password) values('#{params[:username]}','#{params[:password]}')")
      redirect "/"
    end
  end

  post "/login" do
    if params[:username] == ""
      flash.now[:notice] = "username cannot be blank"
      erb :index
    elsif params[:password] == ""
      flash.now[:notice] = "password cannot be blank"
      erb :index
    elsif @database_connection.sql("select * from users where username = '#{params[:username]}' and password = '#{params[:password]}'") == []
      flash.now[:notice] = "cannot find username and/or password"
      erb :index
    else
      id_array = @database_connection.sql("SELECT id FROM users WHERE username ='#{params[:username]}' and password = '#{params[:password]}'")
      id_hash = id_array.first
      id = id_hash["id"]
      session[:user_id] = id
      redirect '/'
    end
  end

  post "/logout" do
    session.delete(:user_id)
    redirect "/"
  end

  get "/sort" do

    if params[:ascending] == "on"
      other_users = @database_connection.sql("select username from users where id != #{session[:user_id]} order by username")
      erb :sorted, locals: {other_users: other_users}
    elsif params[:descending] == "on"
      other_users = @database_connection.sql("select username from users where id != #{session[:user_id]} order by username desc")
      erb :sorted, locals: {other_users: other_users}
    end

  end

  post "/" do
    @database_connection.sql("delete from users where username = '#{params[:username]}'")
    redirect "/"
  end

  get "/add_fish" do
    erb :add_fish
  end

  post "/add_fish" do
    user_id = session[:user_id]
    @database_connection.sql("insert into fish (fish_name, wiki_link, user_id) values('#{params[:fish_name]}','#{params[:wiki_link]}',#{user_id})")
    redirect "/"
  end

  get "/:name" do
    username = params[:name]
    user = @database_connection.sql("select * from users where username = '#{username}'").first
    users_fish = @database_connection.sql("select * from fish where user_id = '#{user["id"]}'")
    erb :users_fish, locals: {user: user, users_fish: users_fish}
  end

  post "/favorite/:fish" do
    fish = @database_connection.sql("select * from fish where fish_name = '#{params[:fish]}'").first
    if params[:favorite] == "on"
      @database_connection.sql("insert into favorite_fish(user_id, fish_id) values('#{session[:user_id]}', '#{fish["id"]}')")
      redirect "/"
    end
    redirect "/"

  end

  private

  def current_user
    if session[:user_id]
      @database_connection.sql("select id from users where id = #{session[:user_id]}")
    end
  end

  def favorite_fish
    fav_fish = @database_connection.sql("select * from favorite_fish where user_id = '#{session[:user_id]}'")
    p fav_fish
    @database_connection.sql("select * from fish where id = 3")
  end
end

