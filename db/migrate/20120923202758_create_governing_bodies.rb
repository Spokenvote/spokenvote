class CreateGoverningBodies < ActiveRecord::Migration
  def change
    create_table :governing_bodies do |t|
      t.string :name
      t.text :description
      t.string :location

      t.timestamps
    end
  end
end
