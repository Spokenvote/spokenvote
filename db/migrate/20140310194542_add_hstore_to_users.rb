class AddHstoreToUsers < ActiveRecord::Migration
  def change
    add_column :users, :preferences, :hstore
  end

  def up
    add_index :users, [:preferences], name: "users_gin_preferences", using: :gin
  end

  def down
    remove_index :users, name: "users_gin_preferences"
  end
end
