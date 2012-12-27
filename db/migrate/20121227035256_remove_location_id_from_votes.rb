class RemoveLocationIdFromVotes < ActiveRecord::Migration
  def up
    remove_column :votes, :location_id
  end

  def down
    add_column :votes, :location_id, :integer
  end
end
