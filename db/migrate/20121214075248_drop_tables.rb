class DropTables < ActiveRecord::Migration
  def change
    drop_table :hubs_positions
    drop_table :tags
    drop_table :positions_tags
    drop_table :vote_versions
  end
end
