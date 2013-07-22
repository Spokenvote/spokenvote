class AddMissingIndexes < ActiveRecord::Migration
  def change
    add_index :proposals, :user_id
    add_index :proposals, :hub_id
    add_index :votes, [:proposal_id, :user_id]
    add_index :votes, :proposal_id
    add_index :votes, :user_id
    add_index :authentications, :user_id
  end
end
