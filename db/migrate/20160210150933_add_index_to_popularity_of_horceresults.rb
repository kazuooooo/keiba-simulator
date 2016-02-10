class AddIndexToPopularityOfHorceresults < ActiveRecord::Migration
  def change
    add_index :horceresults, :popularity
  end
end
