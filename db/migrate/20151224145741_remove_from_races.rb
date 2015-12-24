class RemoveFromRaces < ActiveRecord::Migration
  def change
    remove_column :races, :place
    remove_column :races, :ranking
    remove_column :races, :frame_num
    remove_column :races, :horce_num
    remove_column :races, :popularity
    remove_column :races, :odds
  end
end
