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

ActiveRecord::Schema.define(version: 20180223214808) do

  create_table "bank_payments", force: :cascade do |t|
    t.integer  "account_id"
    t.decimal  "amount",        precision: 10, scale: 2
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "row_id"
    t.boolean  "transfer",                               default: false
    t.date     "validfrom"
    t.date     "validto"
    t.string   "curcode"
    t.datetime "datum"
    t.string   "debitaccount"
    t.string   "debitbank"
    t.string   "creditaccount"
    t.string   "creditbank"
    t.string   "varsym"
    t.string   "constsym"
    t.string   "info"
    t.string   "ekonto_status"
    t.string   "accname"
    t.string   "specsym"
    t.string   "type"
  end

  create_table "bodies", force: :cascade do |t|
    t.string   "type"
    t.string   "name"
    t.string   "acronym"
    t.integer  "organization_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
    t.integer  "display_position"
  end

  add_index "bodies", ["slug"], name: "index_bodies_on_slug", unique: true

  create_table "contacts", force: :cascade do |t|
    t.string   "contactable_type"
    t.integer  "contactable_id"
    t.string   "contact_type"
    t.string   "contact"
    t.string   "privacy"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "councilors", force: :cascade do |t|
    t.string   "council_name"
    t.string   "voting_party"
    t.string   "person_name"
    t.string   "person_party"
    t.integer  "person_id"
    t.integer  "region_id"
    t.date     "since"
    t.date     "till"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "council_type"
  end

  create_table "events", force: :cascade do |t|
    t.string   "uuid"
    t.integer  "requestor_id"
    t.string   "eventable_type"
    t.integer  "eventable_id"
    t.string   "command"
    t.text     "metadata"
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.integer  "old_domestic_region_id"
    t.integer  "old_domestic_branch_id"
    t.integer  "domestic_region_id"
    t.integer  "domestic_branch_id"
    t.integer  "old_guest_region_id"
    t.integer  "old_guest_branch_id"
    t.integer  "guest_region_id"
    t.integer  "guest_branch_id"
  end

  create_table "identities", force: :cascade do |t|
    t.string   "uid"
    t.string   "provider"
    t.integer  "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "identities", ["person_id"], name: "index_identities_on_person_id"

  create_table "issued_token_log_entries", force: :cascade do |t|
    t.integer  "person_id"
    t.datetime "issued_at"
    t.string   "token_id"
    t.string   "audience"
    t.string   "ip_address"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notes", force: :cascade do |t|
    t.string   "noteable_type"
    t.integer  "noteable_id"
    t.text     "content"
    t.integer  "created_by"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "oauth_access_grants", force: :cascade do |t|
    t.integer  "resource_owner_id", null: false
    t.integer  "application_id",    null: false
    t.string   "token",             null: false
    t.integer  "expires_in",        null: false
    t.text     "redirect_uri",      null: false
    t.datetime "created_at",        null: false
    t.datetime "revoked_at"
    t.string   "scopes"
  end

  add_index "oauth_access_grants", ["token"], name: "index_oauth_access_grants_on_token", unique: true

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.integer  "resource_owner_id"
    t.integer  "application_id"
    t.string   "token",             null: false
    t.string   "refresh_token"
    t.integer  "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at",        null: false
    t.string   "scopes"
  end

  add_index "oauth_access_tokens", ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true
  add_index "oauth_access_tokens", ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id"
  add_index "oauth_access_tokens", ["token"], name: "index_oauth_access_tokens_on_token", unique: true

  create_table "oauth_applications", force: :cascade do |t|
    t.string   "name",                      null: false
    t.string   "uid",                       null: false
    t.string   "secret",                    null: false
    t.text     "redirect_uri",              null: false
    t.string   "scopes",       default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "oauth_applications", ["uid"], name: "index_oauth_applications_on_uid", unique: true

  create_table "organizations", force: :cascade do |t|
    t.string   "type"
    t.string   "name"
    t.integer  "parent_id"
    t.integer  "ruian_vusc_id"
    t.string   "nuts3_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "fio_account_number"
    t.string   "fio_token"
    t.string   "address_line"
    t.string   "homepage_url"
    t.string   "slug"
    t.string   "fb_page_url"
  end

  add_index "organizations", ["slug"], name: "index_organizations_on_slug", unique: true

  create_table "people", force: :cascade do |t|
    t.string   "name_prefix"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "name_suffix"
    t.string   "birth_number"
    t.date     "date_of_birth"
    t.string   "legacy_type"
    t.string   "username"
    t.string   "phone"
    t.boolean  "phone_public"
    t.string   "public_email"
    t.text     "previous_political_parties"
    t.string   "domestic_address_street"
    t.string   "domestic_address_city"
    t.string   "domestic_address_zip"
    t.integer  "domestic_address_ruian_id"
    t.string   "postal_address_street"
    t.string   "postal_address_city"
    t.string   "postal_address_zip"
    t.integer  "postal_address_ruian_id"
    t.string   "photo_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                      default: "",   null: false
    t.string   "encrypted_password",         default: "",   null: false
    t.string   "password_salt",              default: "",   null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",              default: 0,    null: false
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
    t.string   "homepage_url"
    t.string   "fb_profile_url"
    t.string   "fb_page_url"
    t.text     "previous_candidatures"
    t.integer  "amount"
    t.string   "status"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.integer  "failed_attempts",            default: 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "cv_file_name"
    t.string   "cv_content_type"
    t.integer  "cv_file_size"
    t.datetime "cv_updated_at"
    t.date     "paid_till"
    t.boolean  "snail_newsletter",           default: true
    t.text     "description"
  end

  add_index "people", ["confirmation_token"], name: "index_people_on_confirmation_token", unique: true
  add_index "people", ["reset_password_token"], name: "index_people_on_reset_password_token", unique: true

  create_table "profile_pictures", force: :cascade do |t|
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.integer  "person_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string   "type"
    t.integer  "person_id"
    t.integer  "body_id"
    t.integer  "branch_id"
    t.date     "since"
    t.date     "till"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "person_name"
    t.string   "branch_name"
    t.string   "department"
  end

  create_table "ruian_addresses", force: :cascade do |t|
    t.string   "mestska_cast"
    t.integer  "mestska_cast_id"
    t.string   "obec"
    t.integer  "obec_id"
    t.string   "kraj"
    t.integer  "kraj_id"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "okres"
    t.integer  "okres_id"
    t.string   "orp"
    t.integer  "orp_id"
  end

  create_table "signed_applications", force: :cascade do |t|
    t.integer  "person_id"
    t.string   "scan_file_name"
    t.string   "scan_content_type"
    t.integer  "scan_file_size"
    t.datetime "scan_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["context"], name: "index_taggings_on_context"
  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
  add_index "taggings", ["tag_id"], name: "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"
  add_index "taggings", ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
  add_index "taggings", ["taggable_id"], name: "index_taggings_on_taggable_id"
  add_index "taggings", ["taggable_type"], name: "index_taggings_on_taggable_type"
  add_index "taggings", ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
  add_index "taggings", ["tagger_id"], name: "index_taggings_on_tagger_id"

  create_table "tags", force: :cascade do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true

  create_table "tasks", force: :cascade do |t|
    t.text     "name"
    t.text     "description"
    t.integer  "author_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "person_id"
    t.datetime "assigned_at"
    t.datetime "finished_at"
    t.datetime "reviewed_at"
  end

  create_table "versions", force: :cascade do |t|
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
