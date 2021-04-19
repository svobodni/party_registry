# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_04_18_182500) do

  create_table "active_storage_attachments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "bank_payments", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "account_id"
    t.decimal "amount", precision: 10, scale: 2
    t.string "status"
    t.integer "row_id"
    t.boolean "transfer", default: false
    t.date "validfrom"
    t.date "validto"
    t.string "curcode"
    t.datetime "datum"
    t.string "debitaccount"
    t.string "debitbank"
    t.string "creditaccount"
    t.string "creditbank"
    t.string "varsym"
    t.string "constsym"
    t.string "info"
    t.string "ekonto_status"
    t.string "accname"
    t.string "specsym"
    t.string "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bodies", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "type"
    t.string "name"
    t.string "acronym"
    t.integer "organization_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "slug"
    t.integer "display_position"
    t.index ["slug"], name: "index_bodies_on_slug", unique: true
  end

  create_table "candidates_list_files", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "sheet_file_name"
    t.string "sheet_content_type"
    t.integer "sheet_file_size"
    t.datetime "sheet_updated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "candidates_lists", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "druh_zastupitelstva"
    t.integer "kod_zastupitelstva"
    t.string "nazev_zastupitelstva"
    t.integer "volebni_obvod"
    t.string "nazev_volebni_strany"
    t.string "typ_volebni_strany"
    t.string "nazev_strany_a_hnuti"
    t.integer "pocet_clenu_zastupitelstva"
    t.string "zmocnenec_jmeno"
    t.string "zmocnenec_adresa"
    t.string "nahradnik_jmeno"
    t.string "nahradnik_adresa"
    t.text "kandidati"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "candidates_list_file_id"
    t.string "poznamka"
  end

  create_table "contacts", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "contactable_type"
    t.integer "contactable_id"
    t.string "contact_type"
    t.string "contact"
    t.string "privacy"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "councilors", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "council_name"
    t.string "voting_party"
    t.string "person_name"
    t.string "person_party"
    t.integer "person_id"
    t.integer "region_id"
    t.date "since"
    t.date "till"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "council_type"
  end

  create_table "events", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "uuid"
    t.integer "requestor_id"
    t.string "eventable_type"
    t.integer "eventable_id"
    t.string "command"
    t.text "metadata"
    t.text "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "name"
    t.integer "old_domestic_region_id"
    t.integer "old_domestic_branch_id"
    t.integer "domestic_region_id"
    t.integer "domestic_branch_id"
    t.integer "old_guest_region_id"
    t.integer "old_guest_branch_id"
    t.integer "guest_region_id"
    t.integer "guest_branch_id"
  end

  create_table "identities", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "uid"
    t.string "provider"
    t.integer "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["person_id"], name: "index_identities_on_person_id"
  end

  create_table "issued_token_log_entries", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "person_id"
    t.datetime "issued_at"
    t.string "token_id"
    t.string "audience"
    t.string "ip_address"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "membership_requests", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "person_id"
    t.string "previous_status"
    t.date "membership_requested_on"
    t.date "application_received_on"
    t.date "approved_on"
    t.date "paid_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notes", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "noteable_type"
    t.integer "noteable_id"
    t.text "content"
    t.integer "created_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "oauth_access_grants", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "resource_owner_id", null: false
    t.integer "application_id", null: false
    t.string "token", null: false
    t.integer "expires_in", null: false
    t.text "redirect_uri", null: false
    t.datetime "created_at", null: false
    t.datetime "revoked_at"
    t.string "scopes"
    t.index ["token"], name: "index_oauth_access_grants_on_token", unique: true
  end

  create_table "oauth_access_tokens", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "resource_owner_id"
    t.integer "application_id"
    t.string "token", null: false
    t.string "refresh_token"
    t.integer "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at", null: false
    t.string "scopes"
    t.index ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true
    t.index ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_tokens_on_token", unique: true
  end

  create_table "oauth_applications", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "uid", null: false
    t.string "secret", null: false
    t.text "redirect_uri", null: false
    t.string "scopes", default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["uid"], name: "index_oauth_applications_on_uid", unique: true
  end

  create_table "organizations", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "type"
    t.string "name"
    t.integer "parent_id"
    t.integer "ruian_vusc_id"
    t.string "nuts3_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "fio_account_number"
    t.string "fio_token"
    t.string "address_line"
    t.string "homepage_url"
    t.string "slug"
    t.string "fb_page_url"
    t.index ["slug"], name: "index_organizations_on_slug", unique: true
  end

  create_table "people", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name_prefix"
    t.string "first_name"
    t.string "last_name"
    t.string "name_suffix"
    t.string "birth_number"
    t.date "date_of_birth"
    t.string "legacy_type"
    t.string "username"
    t.string "phone"
    t.boolean "phone_public"
    t.string "public_email"
    t.text "previous_political_parties"
    t.string "domestic_address_street"
    t.string "domestic_address_city"
    t.string "domestic_address_zip"
    t.integer "domestic_address_ruian_id"
    t.string "postal_address_street"
    t.string "postal_address_city"
    t.string "postal_address_zip"
    t.integer "postal_address_ruian_id"
    t.string "photo_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "password_salt", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.integer "domestic_region_id"
    t.integer "guest_region_id"
    t.integer "domestic_branch_id"
    t.integer "guest_branch_id"
    t.string "member_status"
    t.string "supporter_status"
    t.string "homepage_url"
    t.string "fb_profile_url"
    t.string "fb_page_url"
    t.text "previous_candidatures"
    t.integer "amount"
    t.string "status"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.integer "failed_attempts", default: 0
    t.string "unlock_token"
    t.datetime "locked_at"
    t.string "cv_file_name"
    t.string "cv_content_type"
    t.integer "cv_file_size"
    t.datetime "cv_updated_at"
    t.date "paid_till"
    t.boolean "snail_newsletter", default: true
    t.text "description"
    t.index ["confirmation_token"], name: "index_people_on_confirmation_token", unique: true
    t.index ["reset_password_token"], name: "index_people_on_reset_password_token", unique: true
  end

  create_table "profile_pictures", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "photo_file_name"
    t.string "photo_content_type"
    t.integer "photo_file_size"
    t.datetime "photo_updated_at"
    t.integer "person_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "type"
    t.integer "person_id"
    t.integer "body_id"
    t.integer "branch_id"
    t.date "since"
    t.date "till"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "person_name"
    t.string "branch_name"
    t.string "department"
  end

  create_table "ruian_addresses", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "mestska_cast"
    t.integer "mestska_cast_id"
    t.string "obec"
    t.integer "obec_id"
    t.string "kraj"
    t.integer "kraj_id"
    t.float "latitude"
    t.float "longitude"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "okres"
    t.integer "okres_id"
    t.string "orp"
    t.integer "orp_id"
  end

  create_table "signed_applications", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "person_id"
    t.string "scan_file_name"
    t.string "scan_content_type"
    t.integer "scan_file_size"
    t.datetime "scan_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "versions", id: :integer, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.text "object_changes"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
end
