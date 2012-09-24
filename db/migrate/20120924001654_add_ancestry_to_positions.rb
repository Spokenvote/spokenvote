class AddAncestryToPositions < ActiveRecord::Migration
  def change
    add_column :positions, :ancestry, :string
    add_index :positions, :ancestry
  end
end
