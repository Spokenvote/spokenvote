class RemoveParentIdFromProposals < ActiveRecord::Migration
  def up
    remove_column :proposals, :parent_id
  end

  def down
    add_column :proposals, :parent_id, :integer
  end
end
