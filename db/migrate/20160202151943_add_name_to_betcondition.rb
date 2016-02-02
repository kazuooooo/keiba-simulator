class AddNameToBetcondition < ActiveRecord::Migration
  def change
    add_column :betconditions, :name , :string
  end
end
