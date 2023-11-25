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

ActiveRecord::Schema[7.0].define(version: 2023_11_25_154749) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "fifty_churches", force: :cascade do |t|
    t.string "parroquia"
    t.bigint "fifty_town_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["fifty_town_id"], name: "index_fifty_churches_on_fifty_town_id"
  end

  create_table "fifty_cities", force: :cascade do |t|
    t.string "ciudad"
    t.bigint "fifty_location_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["fifty_location_id"], name: "index_fifty_cities_on_fifty_location_id"
  end

  create_table "fifty_locations", force: :cascade do |t|
    t.string "iso_31662"
    t.string "estado"
    t.string "capital"
    t.integer "id_estado"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "fifty_stadia", force: :cascade do |t|
    t.string "name"
    t.integer "fifty_location", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "fifty_towns", force: :cascade do |t|
    t.string "municipio"
    t.string "capital"
    t.bigint "fifty_location_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["fifty_location_id"], name: "index_fifty_towns_on_fifty_location_id"
  end

  create_table "rifamax_raffles", force: :cascade do |t|
    t.date "init_date"
    t.string "award_sign"
    t.string "award_no_sign"
    t.string "plate"
    t.integer "year"
    t.string "game", default: "Zodiac"
    t.float "price"
    t.string "loteria"
    t.integer "numbers"
    t.string "serial"
    t.date "expired_date"
    t.boolean "is_send"
    t.boolean "is_closed"
    t.boolean "refund"
    t.integer "rifero_id"
    t.integer "taquilla_id"
    t.integer "payment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rifamax_tickets", force: :cascade do |t|
    t.string "sign"
    t.integer "number"
    t.integer "ticket_nro"
    t.string "serial"
    t.boolean "is_sold", default: false
    t.bigint "rifamax_raffle_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["rifamax_raffle_id"], name: "index_rifamax_tickets_on_rifamax_raffle_id"
  end

  create_table "shared_application_modules", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shared_transactions", force: :cascade do |t|
    t.string "transaction_type"
    t.bigint "shared_wallet_id", null: false
    t.float "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shared_wallet_id"], name: "index_shared_transactions_on_shared_wallet_id"
  end

  create_table "shared_users", force: :cascade do |t|
    t.string "avatar"
    t.string "name"
    t.string "role"
    t.string "dni"
    t.string "email"
    t.string "phone"
    t.string "password_digest"
    t.string "slug"
    t.boolean "is_active"
    t.integer "rifero_ids", default: [], array: true
    t.integer "module_assigned", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shared_wallets", force: :cascade do |t|
    t.string "token", default: "877c9e0a-e72a-47f1-a522-396d7c731c01"
    t.float "found", default: 0.0
    t.float "debt", default: 0.0
    t.float "debt_limit", default: 20.0
    t.bigint "shared_user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shared_user_id"], name: "index_shared_wallets_on_shared_user_id"
  end

  add_foreign_key "fifty_churches", "fifty_towns"
  add_foreign_key "fifty_cities", "fifty_locations"
  add_foreign_key "fifty_towns", "fifty_locations"
  add_foreign_key "rifamax_tickets", "rifamax_raffles"
  add_foreign_key "shared_transactions", "shared_wallets"
  add_foreign_key "shared_wallets", "shared_users"
end
