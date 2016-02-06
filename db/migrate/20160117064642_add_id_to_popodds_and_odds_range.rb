class AddIdToPopoddsAndOddsRange < ActiveRecord::Migration
  def change
    add_column :popconditions, :betcondition_id, :integer
    add_column :oddsranges, :popcondition_id, :integer
  end
end
