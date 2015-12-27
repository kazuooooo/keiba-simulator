class AddIdToHorceresult < ActiveRecord::Migration
  def change
    add_column :horceresults, :race_id, :integer
    add_column :horceresults, :horce_id, :integer
  end
end
