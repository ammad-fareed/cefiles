# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_09_09_153435) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.string "address_line_1"
    t.string "address_line_2"
    t.string "city"
    t.string "state"
    t.string "postal_code"
    t.bigint "country_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["country_id"], name: "index_addresses_on_country_id"
  end

  create_table "ce_categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_ce_categories_on_name"
  end

  create_table "ce_categories_products", force: :cascade do |t|
    t.bigint "ce_category_id"
    t.bigint "product_id"
    t.index ["ce_category_id"], name: "index_ce_categories_products_on_ce_category_id"
    t.index ["product_id"], name: "index_ce_categories_products_on_product_id"
  end

  create_table "ce_categories_standards", force: :cascade do |t|
    t.bigint "ce_category_id"
    t.bigint "standard_id"
    t.index ["ce_category_id"], name: "index_ce_categories_standards_on_ce_category_id"
    t.index ["standard_id"], name: "index_ce_categories_standards_on_standard_id"
  end

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "archived", default: false, null: false
    t.string "website"
    t.integer "address_id"
    t.boolean "admin", default: false, null: false
    t.string "email"
    t.string "phone_number"
    t.integer "industry_id"
    t.boolean "approved"
    t.integer "published_product_limit", default: 10
    t.integer "c_xml_id"
    t.string "plan_name"
    t.string "plan_id"
    t.string "customer_id"
    t.string "subscription_id"
    t.string "stripe_charge_error"
    t.string "current_period_start"
    t.string "current_period_end"
    t.string "deactivated"
    t.string "selected_plan_id"
    t.string "plan_updated_to"
    t.string "plan_updated_from"
    t.string "plan_update_date"
    t.string "subscription_status"
    t.string "unsubscribed_at"
    t.index ["address_id"], name: "index_companies_on_address_id"
    t.index ["approved"], name: "index_companies_on_approved"
    t.index ["archived"], name: "index_companies_on_archived"
    t.index ["c_xml_id"], name: "index_companies_on_c_xml_id"
    t.index ["industry_id"], name: "index_companies_on_industry_id"
    t.index ["name"], name: "index_companies_on_name"
  end

  create_table "countries", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "directives", force: :cascade do |t|
    t.string "code"
    t.string "url"
    t.date "start_date"
    t.bigint "ce_category_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.date "end_date"
    t.boolean "archived", default: false, null: false
    t.index ["archived"], name: "index_directives_on_archived"
    t.index ["ce_category_id"], name: "index_directives_on_ce_category_id"
    t.index ["code"], name: "index_directives_on_code"
  end

  create_table "directives_products", force: :cascade do |t|
    t.bigint "directive_id"
    t.bigint "product_id"
    t.index ["directive_id"], name: "index_directives_products_on_directive_id"
    t.index ["product_id"], name: "index_directives_products_on_product_id"
  end

  create_table "documents", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.boolean "public", default: false
    t.string "file"
    t.bigint "product_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "file_size"
    t.index ["product_id"], name: "index_documents_on_product_id"
    t.index ["public"], name: "index_documents_on_public"
  end

  create_table "enquiries", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.bigint "user_id"
    t.text "content"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_enquiries_on_user_id"
  end

  create_table "eu_representatives", force: :cascade do |t|
    t.string "name"
    t.bigint "address_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["address_id"], name: "index_eu_representatives_on_address_id"
  end

  create_table "industries", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "manufacturers", force: :cascade do |t|
    t.string "name"
    t.bigint "address_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["address_id"], name: "index_manufacturers_on_address_id"
  end

  create_table "product_categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "parent_id"
    t.integer "xml_id"
  end

  create_table "product_declarations", force: :cascade do |t|
    t.string "text"
    t.string "file"
    t.date "expiry_date"
    t.bigint "product_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["product_id"], name: "index_product_declarations_on_product_id"
  end

  create_table "product_remarks", force: :cascade do |t|
    t.text "comments"
    t.bigint "product_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["product_id"], name: "index_product_remarks_on_product_id"
  end

  create_table "product_suppliers", force: :cascade do |t|
    t.bigint "product_id"
    t.bigint "supplier_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["product_id"], name: "index_product_suppliers_on_product_id"
    t.index ["supplier_id"], name: "index_product_suppliers_on_supplier_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.bigint "company_id"
    t.string "model_number"
    t.string "serial_number"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "notified_body_number"
    t.string "ce_mark_year"
    t.text "notes"
    t.string "barcode"
    t.string "image"
    t.boolean "published", default: false
    t.bigint "supplier_id"
    t.bigint "manufacturer_id"
    t.bigint "product_category_id"
    t.bigint "eu_representative_id"
    t.string "share_code"
    t.integer "p_xml_id"
    t.string "p_xml_image"
    t.boolean "is_imported", default: true
    t.boolean "is_approved"
    t.text "eu_countries", default: [], array: true
    t.boolean "searchable"
    t.index ["company_id"], name: "index_products_on_company_id"
    t.index ["eu_representative_id"], name: "index_products_on_eu_representative_id"
    t.index ["manufacturer_id"], name: "index_products_on_manufacturer_id"
    t.index ["name"], name: "index_products_on_name"
    t.index ["p_xml_id"], name: "index_products_on_p_xml_id"
    t.index ["product_category_id"], name: "index_products_on_product_category_id"
    t.index ["share_code"], name: "index_products_on_share_code"
    t.index ["supplier_id"], name: "index_products_on_supplier_id"
  end

  create_table "products_standards", force: :cascade do |t|
    t.bigint "product_id"
    t.bigint "standard_id"
    t.index ["product_id"], name: "index_products_standards_on_product_id"
    t.index ["standard_id"], name: "index_products_standards_on_standard_id"
  end

  create_table "standards", force: :cascade do |t|
    t.string "code"
    t.text "name"
    t.string "organisation"
    t.date "expiry_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "url"
    t.boolean "archived", default: false
    t.index ["archived"], name: "index_standards_on_archived"
    t.index ["code"], name: "index_standards_on_code"
    t.index ["name"], name: "index_standards_on_name"
    t.index ["organisation"], name: "index_standards_on_organisation"
  end

  create_table "suppliers", force: :cascade do |t|
    t.string "name"
    t.bigint "address_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "phone"
    t.string "email"
    t.index ["address_id"], name: "index_suppliers_on_address_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "given_name", default: "", null: false
    t.string "family_name", default: "", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "company_id"
    t.boolean "archived", default: false, null: false
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.boolean "approved"
    t.boolean "accepted_privacy"
    t.boolean "should_receive_ce_updates", default: false
    t.index ["approved"], name: "index_users_on_approved"
    t.index ["archived"], name: "index_users_on_archived"
    t.index ["company_id"], name: "index_users_on_company_id"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["family_name"], name: "index_users_on_family_name"
    t.index ["given_name"], name: "index_users_on_given_name"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.bigint "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

end
