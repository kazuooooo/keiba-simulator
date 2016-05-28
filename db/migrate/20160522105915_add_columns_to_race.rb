class AddColumnsToRace < ActiveRecord::Migration
  def change
    # 日付,場所,R,レース名,コース,周り,距離,天候,馬場,着順,枠番,馬番,馬名,人気順,オッズ
    add_column :races, :course, :string
    add_column :races, :rotation, :string
    add_column :races, :distance, :integer
    add_column :races, :weather, :integer
    add_column :races, :course_condition, :integer
  end
end
