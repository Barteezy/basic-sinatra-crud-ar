class UsersTable
  def initialize(database_connection)
    @database_connection = database_connection
  end

  def create(username, password)
    insert_user_sql = <<-SQL
      INSERT INTO users (username, password)
      VALUES ('#{username}', '#{password}')
      RETURNING id
    SQL

    @database_connection.sql(insert_user_sql).first["id"]
  end

  def find(id)
    find_sql = <<-SQL
      SELECT * FROM users
      WHERE id = #{id}
    SQL

    @database_connection.sql(find_sql).first
  end

  def find_by(username, password)
    find_by_sql = <<-SQL
      SELECT * FROM users
      WHERE username = '#{username}'
      AND password = '#{password}'
    SQL

    @database_connection.sql(find_by_sql).first
  end

  def find_by_name(username)
    find_by_sql = <<-SQL
      SELECT * FROM users
      WHERE username = '#{username}'
    SQL

    @database_connection.sql(find_by_sql).first
  end

  def other_users(id)
    find_sql = <<-SQL
      SELECT * FROM users
      WHERE id != #{id}
    SQL

    @database_connection.sql(find_sql)

  end

  def sort(id)
    find_sql = <<-SQL
      SELECT * FROM users
      WHERE id != #{id} ORDER BY username
    SQL

    @database_connection.sql(find_sql)
  end

  def reverse_sort(id)
    find_sql = <<-SQL
      SELECT * FROM users
      WHERE id != #{id} ORDER BY username DESC
    SQL
    @database_connection.sql(find_sql)
  end


  def delete(user)
    find_sql = <<-SQL
    DELETE FROM users
    WHERE username = '#{user}'
    SQL
    @database_connection.sql(find_sql)
  end

end


