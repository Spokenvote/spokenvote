class ChangeColumn < ActiveRecord::Migration
  def up
    change_column :users, :email, :string, :null => true
  end

  def down
    change_column :users, :email, :string, :null => false
  end
end
