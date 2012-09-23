class AddGoverningIdToPositions < ActiveRecord::Migration
  def change
    add_column :positions, :governing_id, :integer
  end
end
