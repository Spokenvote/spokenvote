class AddVotesCountToPositions < ActiveRecord::Migration
  def change
    add_column :proposals, :votes_count, :integer, :default => 0
  end
end
