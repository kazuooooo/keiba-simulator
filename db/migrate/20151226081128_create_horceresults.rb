class CreateHorceresults < ActiveRecord::Migration
  def change
    create_table :horceresults do |t|
      t.integer :race_id
      t.integer :horce_id
      t.float :odds
      t.integer :popularity
      t.integer :horce_num
      t.integer :frame_num
      t.integer :ranking
      t.timestamps null: false
    end
  end
end
