class RenamePositionsToProposals < ActiveRecord::Migration
  def change
    rename_table :proposals, :proposals
  end
end
