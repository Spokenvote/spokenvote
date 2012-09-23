class CreatePositionsTags < ActiveRecord::Migration
  def change
    create_table :positions_tags do |t|

      t.timestamps
    end
  end
end
