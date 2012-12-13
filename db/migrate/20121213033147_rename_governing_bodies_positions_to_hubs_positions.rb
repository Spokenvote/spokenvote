class RenameGoverningBodiesPositionsToHubsPositions < ActiveRecord::Migration
  def up
    rename_table :governing_bodies_positions, :hubs_positions
  end

  def down
    rename_table :hubs_positions, :governing_bodies_positions
  end
end
