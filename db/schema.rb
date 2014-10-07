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

ActiveRecord::Schema.define(version: 20141007034014) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "bikeway_segments", force: true do |t|
    t.integer  "city_rid"
    t.integer  "city_geo_id"
    t.integer  "city_linear_feature_name_id"
    t.integer  "city_object_id"
    t.string   "full_street_name"
    t.string   "address_left"
    t.string   "address_right"
    t.string   "odd_even_flag_left"
    t.string   "odd_even_flag_right"
    t.integer  "lowest_address_left"
    t.integer  "lowest_address_right"
    t.integer  "highest_address_left"
    t.integer  "highest_address_right"
    t.integer  "from_intersection_id"
    t.integer  "to_intersection_id"
    t.string   "street_classification"
    t.string   "bikeway_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.spatial  "geom",                        limit: {:srid=>4326, :type=>"geometry"}
    t.integer  "bikeway_id"
  end

  add_index "bikeway_segments", ["bikeway_id"], :name => "index_bikeway_segments_on_bikeway_id"

  create_table "bikeways", force: true do |t|
    t.string  "bikeway_name"
    t.integer "portion"
    t.string  "description"
    t.integer "length_m"
    t.integer "bikeway_route_number"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
