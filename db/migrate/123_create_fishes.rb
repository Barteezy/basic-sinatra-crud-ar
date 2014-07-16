class CreateFishes < ActiveRecord::Migration
  def up
    create_table :fishes do |t|
      t.string :fish_name
      t.string :wiki_link
      t.string :user_id
    end
  end

  def down
    drop_table :fishes
  end
end
