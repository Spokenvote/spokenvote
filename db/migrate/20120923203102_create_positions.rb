class CreatePositions < ActiveRecord::Migration
  def change
    create_table :positions do |t|
      t.string :statement
      t.integer :user_id
      t.integer :parent_id

      t.timestamps
    end
  end
end
