class AddRaceNameToRaces < ActiveRecord::Migration
  def change
    add_column :races, :race_name, :string
  end
end
