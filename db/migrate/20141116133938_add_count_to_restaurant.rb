class AddCountToRestaurant < ActiveRecord::Migration
  def change
    add_column :restaurants, :count, :integer, :default => 1
  end
end
