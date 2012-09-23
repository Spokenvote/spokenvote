class CreateVoteVersions < ActiveRecord::Migration
  def up
    create_table :page_versions do |t|
      t.integer :vote_id, :version, :vote_id
      t.string  :position_id, :version
      t.timestamps
    end
  end

  def down
  end
end
