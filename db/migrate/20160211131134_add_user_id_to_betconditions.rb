class AddUserIdToBetconditions < ActiveRecord::Migration
  def change
    add_column :betconditions, :user_id, :integer
  end
end
