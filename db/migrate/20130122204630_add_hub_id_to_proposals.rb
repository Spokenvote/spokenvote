class AddHubIdToProposals < ActiveRecord::Migration
  def change
    add_column :proposals, :hub_id, :integer
  end
end
