class CreateRestaurants < ActiveRecord::Migration
  def change
    create_table :restaurants do |t|
      t.string :name
      t.string :address
      t.float :lng
      t.float :lat
      t.timestamps
    end
  end
end
