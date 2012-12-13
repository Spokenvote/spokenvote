class RenameGoverningBodyToHub < ActiveRecord::Migration
  def up
    rename_table :governing_bodies, :hubs
  end

  def down
    rename_table :hubs, :governing_bodies
  end
end
