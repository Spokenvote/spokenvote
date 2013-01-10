class Changecolumnname < ActiveRecord::Migration
  def change
    rename_column :hubs, :group, :group_name
  end
end
