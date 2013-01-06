class ChangeLocationTypeToTypeId < ActiveRecord::Migration
  def up
    rename_column :locations, :type, :type_id
  end

  def down
    rename_column :locations, :type_id, :type
  end
end
