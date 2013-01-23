class RemoveHubIdFromVotes < ActiveRecord::Migration
  def up
    remove_column :votes, :hub_id
  end

  def down
    add_column :votes, :hub_id
  end
end
