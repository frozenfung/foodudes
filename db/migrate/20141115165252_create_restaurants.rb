class CreateRestaurants < ActiveRecord::Migration
  def change
    create_table :restaurants do |t|
      t.string :name
      t.string :address
      t.string :description
      t.string :dish
      t.string :notice
      t.float :lng
      t.float :lat
      t.timestamps
    end
  end
end
