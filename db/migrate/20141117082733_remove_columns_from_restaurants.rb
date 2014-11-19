class RemoveColumnsFromRestaurants < ActiveRecord::Migration
  def change
    remove_column :restaurants, :description
    remove_column :restaurants, :dish
    remove_column :restaurants, :notice
    remove_column :restaurants, :count
  end
end
