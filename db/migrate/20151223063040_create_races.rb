class CreateRaces < ActiveRecord::Migration
  def change
    create_table :races do |t|
      t.date :date
      t.string :place
      t.string :race_num
      t.integer :ranking
      t.integer :frame_num
      t.integer :horce_num
      t.integer :popularity
      t.float :odds
      t.timestamps null: false
    end
  end
end
