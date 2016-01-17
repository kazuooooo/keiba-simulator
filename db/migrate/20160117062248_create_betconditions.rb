class CreateBetconditions < ActiveRecord::Migration
  def change
    create_table :betconditions do |t|
      t.integer :place_id
      t.date :start_date
      t.date :end_date

      t.timestamps null: false
    end
  end
end
