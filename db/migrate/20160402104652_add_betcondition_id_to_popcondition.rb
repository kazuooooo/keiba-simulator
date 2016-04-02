class AddBetconditionIdToPopcondition < ActiveRecord::Migration
  def change
    add_column :popconditions, :betcondition_id, :integer
  end
end
