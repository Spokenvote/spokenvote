class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :label
      t.string :slug

      t.timestamps
    end
  end
end
