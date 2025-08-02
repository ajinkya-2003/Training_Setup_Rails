class CreateRestaurantTables < ActiveRecord::Migration[8.0]
  def change
    create_table :restaurant_tables do |t|
      t.integer :table_number
      t.integer :capacity
      t.string :status
      t.references :restaurant, null: false, foreign_key: true

      t.timestamps
    end
  end
end
