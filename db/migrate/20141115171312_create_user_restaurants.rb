class CreateUserRestaurants < ActiveRecord::Migration
  def change
    create_table :user_restaurants do |t|
      t.integer :user_id
      t.integer :restaurant_id

      t.timestamps
    end
    add_index :user_restaurants, :user_id
    add_index :user_restaurants, :restaurant_id
  end
end
