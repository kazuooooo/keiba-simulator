class DropOddsrange < ActiveRecord::Migration
  def change
    drop_table :oddsranges
  end
end
