class AddAncestryToPositions < ActiveRecord::Migration
  def change
    add_column :proposals, :ancestry, :string
    add_index :proposals, :ancestry
  end
end
