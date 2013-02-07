class AddUniqueIndexToHubs < ActiveRecord::Migration
  def change
    add_index :hubs, [:formatted_location, :group_name], :unique => true
  end
end
