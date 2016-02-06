class AddOddsRangeToPopconditions < ActiveRecord::Migration
  def change
    add_column :popconditions, :odds_start, :decimal
    add_column :popconditions, :odds_end,   :decimal
  end
end
