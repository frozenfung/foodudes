# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20141208090222) do

  create_table "friendships", force: true do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "recommends", force: true do |t|
    t.integer  "user_id"
    t.integer  "restaurant_id"
    t.string   "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "restaurants", force: true do |t|
    t.string   "name"
    t.string   "address",                                default: "抱歉！目前沒有資料"
    t.decimal  "lng",          precision: 25, scale: 20
    t.decimal  "lat",          precision: 25, scale: 20
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "phone_number",                           default: "抱歉！目前沒有資料"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "image"
    t.string   "fb_uid"
    t.string   "fb_token"
    t.datetime "fb_expires_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "mobile_id"
  end

  add_index "users", ["mobile_id"], name: "index_users_on_mobile_id", using: :btree

end
