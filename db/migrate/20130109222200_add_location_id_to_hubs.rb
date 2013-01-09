class AddLocationIdToHubs < ActiveRecord::Migration
  def change
    add_column :hubs, :location_id, :integer
    rename_column :hubs, :name, :group
  end
end
