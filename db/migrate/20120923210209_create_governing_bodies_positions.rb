class CreateGoverningBodiesPositions < ActiveRecord::Migration
  def change
    create_table :governing_bodies_positions do |t|
      t.integer :governing_body_id
      t.integer :position_id
    end
  end
end
