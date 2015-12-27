class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.integer :place_id
      t.string :name
      t.timestamps null: false
    end
  end
end
