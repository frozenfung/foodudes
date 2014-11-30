class AddColumnPhoneNumberRestaurants < ActiveRecord::Migration
  def change
    add_column :restaurants, :phone_number, :string
  end
end
