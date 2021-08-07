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

ActiveRecord::Schema.define(version: 2021_08_07_143214) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cash_transactions", force: :cascade do |t|
    t.bigint "user_id"
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "foreign", default: false
    t.boolean "converted", default: false
    t.index ["user_id"], name: "index_cash_transactions_on_user_id"
  end

  create_table "points", force: :cascade do |t|
    t.bigint "user_id"
    t.decimal "value", precision: 10, scale: 2, null: false
    t.boolean "expired", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "account_type", default: 0
    t.bigint "cash_transaction_id"
    t.boolean "rewarded", default: false
    t.index ["cash_transaction_id"], name: "index_points_on_cash_transaction_id"
    t.index ["user_id"], name: "index_points_on_user_id"
  end

  create_table "rewards", force: :cascade do |t|
    t.string "name"
    t.integer "points_needed"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "per_transaction"
    t.integer "per_monthly_accumulation"
    t.boolean "per_birthmonth", default: false
    t.integer "per_first_days_transactions"
    t.boolean "per_gold_tier", default: false
  end

  create_table "user_rewards", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "reward_id"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "date_used"
    t.index ["reward_id"], name: "index_user_rewards_on_reward_id"
    t.index ["user_id"], name: "index_user_rewards_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "birthdate"
    t.integer "tier", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "balance_points"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
