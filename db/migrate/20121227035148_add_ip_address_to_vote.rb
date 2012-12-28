class AddIpAddressToVote < ActiveRecord::Migration
  def change
    add_column :votes, :ip_address, :string
  end
end
