class AddFormattedLocationToHubs < ActiveRecord::Migration
  def change
    add_column :hubs, :formatted_location, :string
    change_column :hubs, :location_id, :string
  end
end
