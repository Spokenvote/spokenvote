class DropLocations < ActiveRecord::Migration
  def up
    drop_table :locations
  end

  def down
    create_table :locations do |t|
      t.string :name
      t.integer :type_id
      t.integer :parent_id
      t.string :ancestry

      t.timestamps
    end
  end
end
