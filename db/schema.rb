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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120928002405) do

  create_table "connections", :force => true do |t|
    t.integer  "giver_id"
    t.integer  "receiver_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "connections", ["giver_id"], :name => "index_connections_on_giver_id"
  add_index "connections", ["receiver_id"], :name => "index_connections_on_receiver_id"

  create_table "employees", :force => true do |t|
    t.integer  "provider_id",                      :null => false
    t.integer  "user_id",                          :null => false
    t.string   "clearance",   :default => "staff"
    t.boolean  "active",      :default => true
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  create_table "gifts", :force => true do |t|
    t.string   "giver_name"
    t.string   "receiver_name"
    t.string   "provider_name"
    t.string   "item_name"
    t.integer  "giver_id"
    t.integer  "receiver_id"
    t.integer  "item_id"
    t.string   "price",                :limit => 20
    t.integer  "quantity",                                                :null => false
    t.string   "total",                :limit => 20
    t.string   "credit_card",          :limit => 100
    t.integer  "provider_id"
    t.text     "message"
    t.text     "special_instructions"
    t.integer  "redeem_id"
    t.string   "status",                              :default => "open"
    t.string   "category"
    t.datetime "created_at",                                              :null => false
    t.datetime "updated_at",                                              :null => false
    t.string   "receiver_phone"
    t.string   "tax"
    t.string   "tip"
    t.integer  "gift_id"
    t.string   "foursquare_id"
    t.string   "facebook_id"
  end

  create_table "items", :force => true do |t|
    t.string  "item_name",   :limit => 50, :null => false
    t.string  "detail"
    t.text    "description"
    t.integer "category",    :limit => 20, :null => false
    t.string  "proof"
    t.string  "type_of"
  end

  create_table "items_menus", :id => false, :force => true do |t|
    t.integer "item_id"
    t.integer "menu_id"
  end

  create_table "locations", :force => true do |t|
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "provider_id"
    t.integer  "user_id"
    t.string   "foursquare_venue_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  create_table "menu_strings", :force => true do |t|
    t.integer  "version"
    t.integer  "provider_id",  :null => false
    t.string   "full_address"
    t.text     "data",         :null => false
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "menus", :force => true do |t|
    t.integer  "provider_id",               :null => false
    t.integer  "item_id",                   :null => false
    t.string   "price",       :limit => 20
    t.integer  "position",    :limit => 8
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "microposts", :force => true do |t|
    t.string   "content",    :null => false
    t.integer  "user_id",    :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "orders", :force => true do |t|
    t.integer  "redeem_id"
    t.integer  "gift_id"
    t.string   "redeem_code"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "server_code"
    t.integer  "server_id"
    t.integer  "provider_id"
  end

  create_table "providers", :force => true do |t|
    t.string   "name",                                              :null => false
    t.string   "zinger"
    t.text     "description"
    t.string   "address"
    t.string   "address_2"
    t.string   "city",              :limit => 32
    t.string   "state",             :limit => 2
    t.string   "zip",               :limit => 16
    t.string   "logo"
    t.datetime "created_at",                                        :null => false
    t.datetime "updated_at",                                        :null => false
    t.string   "phone"
    t.string   "email"
    t.string   "twitter"
    t.string   "facebook"
    t.string   "website"
    t.string   "photo"
    t.string   "sales_tax"
    t.boolean  "active",                          :default => true
    t.string   "account_name"
    t.string   "aba"
    t.string   "routing"
    t.string   "bank_account_name"
    t.string   "bank_address"
    t.string   "bank_city"
    t.string   "bank_state"
    t.string   "bank_zip"
    t.string   "portrait"
    t.string   "box"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "foursquare_id"
  end

  create_table "redeems", :force => true do |t|
    t.integer  "gift_id"
    t.string   "reply_message"
    t.string   "redeem_code"
    t.text     "special_instructions"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  create_table "relationships", :force => true do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "relationships", ["followed_id"], :name => "index_relationships_on_followed_id"
  add_index "relationships", ["follower_id", "followed_id"], :name => "index_relationships_on_follower_id_and_followed_id", :unique => true
  add_index "relationships", ["follower_id"], :name => "index_relationships_on_follower_id"

  create_table "users", :force => true do |t|
    t.string   "email",                                                    :null => false
    t.boolean  "admin",                                 :default => false
    t.string   "photo"
    t.string   "password_digest",                                          :null => false
    t.string   "remember_token",                                           :null => false
    t.datetime "created_at",                                               :null => false
    t.datetime "updated_at",                                               :null => false
    t.string   "address"
    t.string   "address_2"
    t.string   "city",                    :limit => 20
    t.string   "state",                   :limit => 2
    t.string   "zip",                     :limit => 16
    t.string   "credit_number"
    t.string   "phone"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "facebook_id"
    t.string   "handle"
    t.string   "server_code"
    t.string   "twitter"
    t.boolean  "active",                                :default => true
    t.string   "persona",                               :default => ""
    t.string   "foursquare_id"
    t.string   "facebook_access_token"
    t.datetime "facebook_expiry"
    t.string   "foursquare_access_token"
    t.string   "sex"
  end

end
