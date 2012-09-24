class AddVotesCountToPositions < ActiveRecord::Migration
  def change
    add_column :positions, :votes_count, :integer, :default => 0
  end
end
