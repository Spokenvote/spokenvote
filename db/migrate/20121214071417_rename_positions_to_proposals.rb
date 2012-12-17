class RenamePositionsToProposals < ActiveRecord::Migration
  def change
    rename_table :positions, :proposals
  end
end
