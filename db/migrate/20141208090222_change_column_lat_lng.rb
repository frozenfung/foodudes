class ChangeColumnLatLng < ActiveRecord::Migration
  def change
    change_column :restaurants, :lat, :decimal, :precision => 25, :scale => 20
    change_column :restaurants, :lng, :decimal, :precision => 25, :scale => 20
  end
end
