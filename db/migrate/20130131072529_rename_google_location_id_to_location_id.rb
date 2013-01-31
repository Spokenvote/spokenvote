class RenameGoogleLocationIdToLocationId < ActiveRecord::Migration
  def up
    rename_column :hubs, :google_location_id, :location_id
  end

  def down
    rename_column :hubs, :location_id, :google_location_id
  end
end
