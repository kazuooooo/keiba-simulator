class AddHorceIdToHorce < ActiveRecord::Migration
  def change
    add_column :horces, :horce_id, :integer
  end
end
