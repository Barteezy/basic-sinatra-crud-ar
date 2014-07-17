require "sinatra"
require "active_record"
require "rack-flash"
require "gschool_database_connection"
require "./lib/users_table"
require "./lib/fishes_table"

class App < Sinatra::Application
  enable :sessions
  use Rack::Flash

  def initialize
    super
    @users_table = UsersTable.new(GschoolDatabaseConnection::DatabaseConnection.establish(ENV["RACK_ENV"]))
    @fishes_table = FishesTable.new(GschoolDatabaseConnection::DatabaseConnection.establish(ENV["RACK_ENV"]))
  end

  get "/" do
    if session[:id]
      current_user = @users_table.find(session[:id])
      other_users = @users_table.other_users(session[:id])
      users_fish = @fishes_table.find_fish(session[:id])
      # fav_fish = favorite_fish
      erb :logged_in, locals: {:current_user => current_user, :other_users => other_users, :users_fish => users_fish}
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
      # elsif @database_connection.sql("select * from users where username = '#{params[:username]}'") != []
      #   flash.now[:notice] = "username already taken"
    elsif @users_table.find_by(params[:username], params[:password]) !=nil

      flash.now[:notice] = "username already taken"
      erb :register
    else
      # @database_connection.sql("insert into users(username, password) values('#{params[:username]}','#{params[:password]}')")
      @users_table.create(params[:username], params[:password])
      flash[:success] = "Thank you for registering"
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
      # elsif @database_connection.sql("select * from users where username = '#{params[:username]}' and password = '#{params[:password]}'") == []

    elsif @users_table.find_by(params[:username], params[:password]) == nil
      flash.now[:notice] = "cannot find username and/or password"
      erb :index
    end

    user = @users_table.find_by(params[:username], params[:password])
    if user
      session[:id] = user.fetch("id")
      redirect "/"
    else
      flash.now[:notice] = "cannot find username and/or password"
      erb :index

      # id_array = @database_connection.sql("SELECT id FROM users WHERE username ='#{params[:username]}' and password = '#{params[:password]}'")
      # id_hash = id_array.first
      # id = id_hash["id"]
      # session[:user_id] = id

    end
  end


  post "/logout" do
    session.delete(:id)
    redirect "/"
  end

  get "/sort" do

    if params[:ascending] == "on"
      other_users = @users_table.sort(session[:id])
      erb :sorted, locals: {other_users: other_users}
    elsif params[:descending] == "on"
      other_users = @users_table.reverse_sort(session[:id])
      erb :sorted, locals: {other_users: other_users}
    end

  end

  post "/delete/:name" do
    # @database_connection.sql("delete from users where username = '#{params[:username]}'")

    @users_table.delete(params[:name])
    redirect "/"
  end

  get "/add_fish" do
    erb :add_fish
  end

  post "/add_fish" do
    user_id = session[:id]
    if params[:fish_name] == ""
      flash.now[:error] = "Fish must have a name"
      erb :add_fish
    else
      @fishes_table.create(params[:fish_name], params[:wiki_link], user_id)
      redirect "/"
    end
  end

  get "/:name" do
    user = @users_table.find_by_name(params[:name])
    users_fish = @fishes_table.find_fish(user["id"])
    erb :users_fish, locals: {user: user, users_fish: users_fish}
  end

  # post "/favorite/:fish" do
  #   fish = @database_connection.sql("select * from fish where fish_name = '#{params[:fish]}'").first
  #   if params[:favorite] == "on"
  #     @database_connection.sql("insert into favorite_fish(user_id, fish_id) values('#{session[:id]}', '#{fish["id"]}')")
  #     redirect "/"
  #   end
  #   redirect "/"

  # end

  private

  # def current_user
  #   if session[:id]
  #     @database_connection.sql("select id from users where id = #{session[:id]}")
  #   end
  # end

  # def favorite_fish
  #   fav_fish = @database_connection.sql("select * from favorite_fish where user_id = '#{session[:id]}'")
  #   p fav_fish
  #   @database_connection.sql("select * from fish where id = 3")
  # end

end

