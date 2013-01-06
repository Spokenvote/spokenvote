class AddLocationToVotes < ActiveRecord::Migration
  def change
    change_table(:votes) do |t|
      t.references :location
    end
  end
end
