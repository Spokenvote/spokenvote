class AddCreatedByToProposals < ActiveRecord::Migration
  def change
    add_column :proposals, :created_by, :integer
    add_column :votes, :hub_id, :integer
    remove_column :hubs, :location
  end
end
