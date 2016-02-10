class AddIndexToRaces < ActiveRecord::Migration
  def change
    add_index :races, :place_id
    add_index :races, :date
  end
end
