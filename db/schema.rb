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

ActiveRecord::Schema.define(version: 20140223022146) do

  create_table "addresses", force: true do |t|
    t.string   "street"
    t.string   "city"
    t.string   "zip"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "ruian_adresni_misto_id"
    t.string   "ruian_adresni_misto_mestska_cast"
    t.integer  "addressable_id"
    t.string   "addressable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bodies", force: true do |t|
    t.string   "type"
    t.string   "name"
    t.string   "acronym"
    t.integer  "organization_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "organizations", force: true do |t|
    t.string   "type"
    t.string   "name"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "people", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.integer  "domestic_region_id"
    t.integer  "guest_region_id"
    t.integer  "domestic_branch_id"
    t.integer  "guest_branch_id"
    t.string   "member_status"
    t.string   "supporter_status"
    t.integer  "registered_address_id"
    t.integer  "postal_address_id"
  end

  add_index "people", ["email"], name: "index_people_on_email", unique: true
  add_index "people", ["reset_password_token"], name: "index_people_on_reset_password_token", unique: true

  create_table "roles", force: true do |t|
    t.string   "type"
    t.integer  "person_id"
    t.integer  "body_id"
    t.integer  "branch_id"
    t.date     "since"
    t.date     "till"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "versions", force: true do |t|
    t.string   "item_type",      null: false
    t.integer  "item_id",        null: false
    t.string   "event",          null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.text     "object_changes"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"

end
