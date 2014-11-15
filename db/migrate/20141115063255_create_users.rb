class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :image
      t.string :fb_uid
      t.string :fb_token
      t.datetime :fb_expires_at
      t.timestamps    
    end
  end
end
