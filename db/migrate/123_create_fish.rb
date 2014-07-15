class CreateFish < ActiveRecord::Migration
  def up
    create_table :fish do |t|
      t.string :fish_name
      t.string :wiki_link
      t.string :user_id
    end
  end

  def down
    drop_table :fish
  end
end
