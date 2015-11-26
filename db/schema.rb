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

ActiveRecord::Schema.define(version: 20151126132357) do

  create_table "bank_payments", force: :cascade do |t|
    t.integer  "account_id",    limit: 4
    t.decimal  "amount",                    precision: 10, scale: 2
    t.string   "status",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "row_id",        limit: 4
    t.boolean  "transfer",                                           default: false
    t.date     "validfrom"
    t.date     "validto"
    t.string   "curcode",       limit: 255
    t.datetime "datum"
    t.string   "debitaccount",  limit: 255
    t.string   "debitbank",     limit: 255
    t.string   "creditaccount", limit: 255
    t.string   "creditbank",    limit: 255
    t.string   "varsym",        limit: 255
    t.string   "constsym",      limit: 255
    t.string   "info",          limit: 255
    t.string   "ekonto_status", limit: 255
    t.string   "accname",       limit: 255
    t.string   "specsym",       limit: 255
    t.string   "type",          limit: 255
  end

  create_table "bodies", force: :cascade do |t|
    t.string   "type",             limit: 255
    t.string   "name",             limit: 255
    t.string   "acronym",          limit: 255
    t.integer  "organization_id",  limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug",             limit: 255
    t.integer  "display_position", limit: 4
  end

  add_index "bodies", ["slug"], name: "index_bodies_on_slug", unique: true, using: :btree

  create_table "contacts", force: :cascade do |t|
    t.string   "contactable_type", limit: 255
    t.integer  "contactable_id",   limit: 4
    t.string   "contact_type",     limit: 255
    t.string   "contact",          limit: 255
    t.string   "privacy",          limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", force: :cascade do |t|
    t.string   "uuid",                   limit: 255
    t.integer  "requestor_id",           limit: 4
    t.string   "eventable_type",         limit: 255
    t.integer  "eventable_id",           limit: 4
    t.string   "command",                limit: 255
    t.text     "metadata",               limit: 65535
    t.text     "data",                   limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",                   limit: 255
    t.integer  "old_domestic_region_id", limit: 4
    t.integer  "old_domestic_branch_id", limit: 4
    t.integer  "domestic_region_id",     limit: 4
    t.integer  "domestic_branch_id",     limit: 4
    t.integer  "old_guest_region_id",    limit: 4
    t.integer  "old_guest_branch_id",    limit: 4
    t.integer  "guest_region_id",        limit: 4
    t.integer  "guest_branch_id",        limit: 4
  end

  create_table "identities", force: :cascade do |t|
    t.string   "uid",        limit: 255
    t.string   "provider",   limit: 255
    t.integer  "person_id",  limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "identities", ["person_id"], name: "index_identities_on_person_id", using: :btree

  create_table "issued_token_log_entries", force: :cascade do |t|
    t.integer  "person_id",  limit: 4
    t.datetime "issued_at"
    t.string   "token_id",   limit: 255
    t.string   "audience",   limit: 255
    t.string   "ip_address", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "oauth_access_grants", force: :cascade do |t|
    t.integer  "resource_owner_id", limit: 4,     null: false
    t.integer  "application_id",    limit: 4,     null: false
    t.string   "token",             limit: 255,   null: false
    t.integer  "expires_in",        limit: 4,     null: false
    t.text     "redirect_uri",      limit: 65535, null: false
    t.datetime "created_at",                      null: false
    t.datetime "revoked_at"
    t.string   "scopes",            limit: 255
  end

  add_index "oauth_access_grants", ["token"], name: "index_oauth_access_grants_on_token", unique: true, using: :btree

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.integer  "resource_owner_id", limit: 4
    t.integer  "application_id",    limit: 4
    t.string   "token",             limit: 255, null: false
    t.string   "refresh_token",     limit: 255
    t.integer  "expires_in",        limit: 4
    t.datetime "revoked_at"
    t.datetime "created_at",                    null: false
    t.string   "scopes",            limit: 255
  end

  add_index "oauth_access_tokens", ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true, using: :btree
  add_index "oauth_access_tokens", ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id", using: :btree
  add_index "oauth_access_tokens", ["token"], name: "index_oauth_access_tokens_on_token", unique: true, using: :btree

  create_table "oauth_applications", force: :cascade do |t|
    t.string   "name",         limit: 255,                null: false
    t.string   "uid",          limit: 255,                null: false
    t.string   "secret",       limit: 255,                null: false
    t.text     "redirect_uri", limit: 65535,              null: false
    t.string   "scopes",       limit: 255,   default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "oauth_applications", ["uid"], name: "index_oauth_applications_on_uid", unique: true, using: :btree

  create_table "organizations", force: :cascade do |t|
    t.string   "type",               limit: 255
    t.string   "name",               limit: 255
    t.integer  "parent_id",          limit: 4
    t.integer  "ruian_vusc_id",      limit: 4
    t.string   "nuts3_id",           limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "fio_account_number", limit: 255
    t.string   "fio_token",          limit: 255
    t.string   "address_line",       limit: 255
    t.string   "homepage_url",       limit: 255
    t.string   "slug",               limit: 255
  end

  add_index "organizations", ["slug"], name: "index_organizations_on_slug", unique: true, using: :btree

  create_table "people", force: :cascade do |t|
    t.string   "name_prefix",                limit: 255
    t.string   "first_name",                 limit: 255
    t.string   "last_name",                  limit: 255
    t.string   "name_suffix",                limit: 255
    t.string   "birth_number",               limit: 255
    t.date     "date_of_birth"
    t.string   "legacy_type",                limit: 255
    t.string   "username",                   limit: 255
    t.string   "phone",                      limit: 255
    t.boolean  "phone_public"
    t.string   "public_email",               limit: 255
    t.text     "previous_political_parties", limit: 65535
    t.string   "domestic_address_street",    limit: 255
    t.string   "domestic_address_city",      limit: 255
    t.string   "domestic_address_zip",       limit: 255
    t.integer  "domestic_address_ruian_id",  limit: 4
    t.string   "postal_address_street",      limit: 255
    t.string   "postal_address_city",        limit: 255
    t.string   "postal_address_zip",         limit: 255
    t.integer  "postal_address_ruian_id",    limit: 4
    t.string   "photo_url",                  limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                      limit: 255,   default: "", null: false
    t.string   "encrypted_password",         limit: 255,   default: "", null: false
    t.string   "password_salt",              limit: 255,   default: "", null: false
    t.string   "reset_password_token",       limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",              limit: 4,     default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",         limit: 255
    t.string   "last_sign_in_ip",            limit: 255
    t.integer  "domestic_region_id",         limit: 4
    t.integer  "guest_region_id",            limit: 4
    t.integer  "domestic_branch_id",         limit: 4
    t.integer  "guest_branch_id",            limit: 4
    t.string   "member_status",              limit: 255
    t.string   "supporter_status",           limit: 255
    t.string   "homepage_url",               limit: 255
    t.string   "fb_profile_url",             limit: 255
    t.string   "fb_page_url",                limit: 255
    t.text     "previous_candidatures",      limit: 65535
    t.integer  "amount",                     limit: 4
    t.string   "status",                     limit: 255
    t.string   "confirmation_token",         limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.integer  "failed_attempts",            limit: 4,     default: 0
    t.string   "unlock_token",               limit: 255
    t.datetime "locked_at"
    t.string   "cv_file_name",               limit: 255
    t.string   "cv_content_type",            limit: 255
    t.integer  "cv_file_size",               limit: 4
    t.datetime "cv_updated_at"
    t.date     "paid_till"
    t.boolean  "snail_newsletter",                         default: true
  end

  add_index "people", ["confirmation_token"], name: "index_people_on_confirmation_token", unique: true, using: :btree
  add_index "people", ["reset_password_token"], name: "index_people_on_reset_password_token", unique: true, using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "type",        limit: 255
    t.integer  "person_id",   limit: 4
    t.integer  "body_id",     limit: 4
    t.integer  "branch_id",   limit: 4
    t.date     "since"
    t.date     "till"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "person_name", limit: 255
    t.string   "branch_name", limit: 255
  end

  create_table "ruian_addresses", force: :cascade do |t|
    t.string   "mestska_cast",    limit: 255
    t.integer  "mestska_cast_id", limit: 4
    t.string   "obec",            limit: 255
    t.integer  "obec_id",         limit: 4
    t.string   "kraj",            limit: 255
    t.integer  "kraj_id",         limit: 4
    t.float    "latitude",        limit: 24
    t.float    "longitude",       limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "okres",           limit: 255
    t.integer  "okres_id",        limit: 4
    t.string   "orp",             limit: 255
    t.integer  "orp_id",          limit: 4
  end

  create_table "signed_applications", force: :cascade do |t|
    t.integer  "person_id",         limit: 4
    t.string   "scan_file_name",    limit: 255
    t.string   "scan_content_type", limit: 255
    t.integer  "scan_file_size",    limit: 4
    t.datetime "scan_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",      limit: 255,   null: false
    t.integer  "item_id",        limit: 4,     null: false
    t.string   "event",          limit: 255,   null: false
    t.string   "whodunnit",      limit: 255
    t.text     "object",         limit: 65535
    t.datetime "created_at"
    t.text     "object_changes", limit: 65535
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

end
