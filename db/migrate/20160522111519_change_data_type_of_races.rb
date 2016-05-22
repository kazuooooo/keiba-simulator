class ChangeDataTypeOfRaces < ActiveRecord::Migration
  def change
    change_column :races, :weather, :string
    change_column :races, :course_condition, :string
  end
end
