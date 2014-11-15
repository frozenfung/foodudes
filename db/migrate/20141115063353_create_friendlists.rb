class CreateFriendlists < ActiveRecord::Migration
  def change
    create_table :friendlists do |t|
      t.string :friend_email
      t.integer :user_id
      t.timestamps


    end
    add_index :friendlists, :user_id
  end
end
