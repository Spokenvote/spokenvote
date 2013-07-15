class ProviderUidRequired < ActiveRecord::Migration
  def up
    change_column :authentications, :provider, :string, :null => false
    change_column :authentications, :uid, :string, :null => false
  end

  def down
    change_column :authentications, :provider, :string, :null => true
    change_column :authentications, :uid, :string, :null => true
  end
end
