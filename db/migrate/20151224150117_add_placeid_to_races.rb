class AddPlaceidToRaces < ActiveRecord::Migration
  def change
    add_column :races, :place_id, :integer
  end
end
