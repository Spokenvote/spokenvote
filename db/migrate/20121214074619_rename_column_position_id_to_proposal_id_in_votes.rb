class RenameColumnPositionIdToProposalIdInVotes < ActiveRecord::Migration
  def change
    rename_column :votes, :position_id, :proposal_id
  end
end
