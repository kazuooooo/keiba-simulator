class AddResultCacheToBetCondition < ActiveRecord::Migration
  def change
    add_column :betconditions, :analyze_result_cache, :text
    add_column :betconditions, :try_result_cache, :text
  end
end
