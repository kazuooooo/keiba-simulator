class CreateOddsranges < ActiveRecord::Migration
  def change
    create_table :oddsranges do |t|
      t.decimal :range_start
      t.decimal :range_end

      t.timestamps null: false
    end
  end
end
