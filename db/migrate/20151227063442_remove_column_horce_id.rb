class RemoveColumnHorceId < ActiveRecord::Migration
  def change
    remove_column :horces, :horce_id
  end
end
