class AddModeToBetcondition < ActiveRecord::Migration
  def change
    add_column :betconditions, :mode, :string
  end
end
