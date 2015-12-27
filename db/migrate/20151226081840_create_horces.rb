class CreateHorces < ActiveRecord::Migration
  def change
    create_table :horces do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
