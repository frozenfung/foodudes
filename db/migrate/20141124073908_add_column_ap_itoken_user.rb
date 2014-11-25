class AddColumnApItokenUser < ActiveRecord::Migration
  def change
    add_column :users, :mobile_id, :string
    add_index :users, :mobile_id
  end
end
