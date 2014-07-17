class FishesTable
  def initialize(database_connection)
    @database_connection = database_connection
  end

  def create(fish_name, wiki_link, user_id)
    insert_fish_sql = <<-SQL
      INSERT INTO fishes (fish_name, wiki_link, user_id)
      VALUES ('#{fish_name}', '#{wiki_link}', '#{user_id}')
      RETURNING id
    SQL

    @database_connection.sql(insert_fish_sql).first["id"]
  end



  def find_by(fish_name, wiki_link)
    find_by_sql = <<-SQL
      SELECT * FROM fishes
      WHERE fish_name = '#{fish_name}'
      AND wiki_link = '#{wiki_link}'
    SQL

    @database_connection.sql(find_by_sql).first
  end

  def find_fish(id)
    find_sql = <<-SQL
      SELECT * FROM fishes
      WHERE user_id = '#{id}'
    SQL

    @database_connection.sql(find_sql)
  end

  def find_fish_by_name(name)
    find_sql = <<-SQL
      SELECT * FROM fishes
      WHERE user_id = '#{name}'
    SQL

    @database_connection.sql(find_sql)
  end


end