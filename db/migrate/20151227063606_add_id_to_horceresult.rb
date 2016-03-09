class AddIdToHorceresult < ActiveRecord::Migration
  def change
    add_column :horceresults, :horce_id, :integer
  end
end
