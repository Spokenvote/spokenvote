class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :position_id
      t.text :comment
      t.integer :user_id

      t.timestamps
    end
  end
end
