class ChangeLatlngFromFloatTodecimal < ActiveRecord::Migration
  def change
    change_column :restaurants, :lat, :decimal, :precision => 15, :scale => 10
    change_column :restaurants, :lng, :decimal, :precision => 15, :scale => 10
  end
end
