class CreatePopconditions < ActiveRecord::Migration
  def change
    create_table :popconditions do |t|
      t.integer :popularity

      t.timestamps null: false
    end
  end
end
