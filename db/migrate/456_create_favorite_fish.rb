class CreateFavoriteFish < ActiveRecord::Migration
  def up
    create_table :favorite_fish do |t|
      t.string :fish_id
      t.string :user_id
    end
  end

  def down
    drop_table :favorite_fish
  end
end