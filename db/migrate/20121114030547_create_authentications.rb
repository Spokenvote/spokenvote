class CreateAuthentications < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.integer :user_id
      t.string :uid
      t.string :provider

      t.timestamps
    end
  end
end
