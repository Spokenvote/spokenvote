class RenameGoverningBodyIdToHubId < ActiveRecord::Migration
  def change
    rename_column :hubs_positions, :governing_body_id, :hub_id
  end
end
