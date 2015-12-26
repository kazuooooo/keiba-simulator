class ChangeDatatypeRaceNumOfRaces < ActiveRecord::Migration
  def change
    change_column :races, :race_num, :integer
  end
end
