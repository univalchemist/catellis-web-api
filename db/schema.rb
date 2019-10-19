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

ActiveRecord::Schema.define(version: 20190921154029) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "customers", force: :cascade do |t|
    t.string "phone_number"
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.bigint "restaurant_id", null: false
    t.string "tags"
    t.index ["restaurant_id"], name: "index_customers_on_restaurant_id"
  end

  create_table "floor_plan_tables", force: :cascade do |t|
    t.bigint "floor_plan_id"
    t.integer "x", default: 0, null: false
    t.integer "y", default: 0, null: false
    t.string "table_number", null: false
    t.integer "table_size", default: 0, null: false
    t.integer "table_type", default: 0, null: false
    t.integer "table_shape", default: 0, null: false
    t.integer "min_covers", default: 0, null: false
    t.integer "max_covers", default: 0, null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "table_rotation", default: 0, null: false
    t.boolean "blocked", default: false
    t.index ["floor_plan_id"], name: "index_floor_plan_tables_on_floor_plan_id"
  end

  create_table "floor_plans", force: :cascade do |t|
    t.bigint "restaurant_id"
    t.string "name", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["restaurant_id"], name: "index_floor_plans_on_restaurant_id"
  end

  create_table "reservation_plan_floor_plans", force: :cascade do |t|
    t.bigint "reservation_plan_id"
    t.bigint "floor_plan_id"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["floor_plan_id"], name: "index_reservation_plan_floor_plans_on_floor_plan_id"
    t.index ["reservation_plan_id"], name: "index_reservation_plan_floor_plans_on_reservation_plan_id"
  end

  create_table "reservation_plans", force: :cascade do |t|
    t.bigint "restaurant_id"
    t.string "name", null: false
    t.integer "priority", default: 100, null: false
    t.time "effective_time_start_at", null: false
    t.time "effective_time_end_at", null: false
    t.time "cust_reservable_start_at", null: false
    t.time "cust_reservable_end_at", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "repeat", default: 0, null: false
    t.datetime "effective_date_start_at"
    t.datetime "effective_date_end_at"
    t.boolean "active_weekday_0", default: false, null: false
    t.boolean "active_weekday_1", default: false, null: false
    t.boolean "active_weekday_2", default: false, null: false
    t.boolean "active_weekday_3", default: false, null: false
    t.boolean "active_weekday_4", default: false, null: false
    t.boolean "active_weekday_5", default: false, null: false
    t.boolean "active_weekday_6", default: false, null: false
    t.index ["restaurant_id"], name: "index_reservation_plans_on_restaurant_id"
  end

  create_table "reservations", force: :cascade do |t|
    t.bigint "restaurant_id"
    t.bigint "customer_id"
    t.datetime "scheduled_start_at", null: false
    t.integer "party_size"
    t.text "party_notes"
    t.integer "reservation_status", default: 0, null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "canceled_at"
    t.bigint "canceled_by_id"
    t.bigint "floor_plan_table_id"
    t.datetime "scheduled_end_at", null: false
    t.string "employee"
    t.string "tags"
    t.float "override_turn_time"
    t.index ["canceled_by_id"], name: "index_reservations_on_canceled_by_id"
    t.index ["customer_id"], name: "index_reservations_on_customer_id"
    t.index ["floor_plan_table_id"], name: "index_reservations_on_floor_plan_table_id"
    t.index ["restaurant_id"], name: "index_reservations_on_restaurant_id"
  end

  create_table "restaurants", force: :cascade do |t|
    t.string "name"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "timezone_name", null: false
    t.time "rest_open_at", default: "2000-01-01 10:00:00", null: false
    t.time "rest_close_at", default: "2000-01-01 22:00:00", null: false
    t.boolean "online", default: false
    t.integer "max_party_size", default: 10
    t.integer "min_party_size", default: 1
    t.integer "online_days_in_advance", default: 45
    t.boolean "email_confirmation_inhouse", default: true
    t.text "email_confirmation_notes"
    t.boolean "email_reminders", default: true
    t.string "email_reminder_time"
    t.string "notification_email_address"
    t.boolean "created_notification", default: true
    t.boolean "edited_notification", default: true
    t.boolean "cancelled_notification", default: true
    t.string "phone_number"
    t.string "location"
    t.float "turn_time_1", default: 1.5
    t.float "turn_time_2", default: 1.75
    t.float "turn_time_3", default: 2.0
    t.float "turn_time_4", default: 2.25
    t.float "turn_time_5", default: 2.5
    t.float "turn_time_6", default: 2.5
    t.float "turn_time_7", default: 2.5
    t.float "turn_time_8", default: 2.5
    t.float "turn_time_9", default: 2.5
    t.float "turn_time_10", default: 2.5
    t.float "turn_time_11", default: 3.0
    t.float "turn_time_12", default: 3.0
    t.float "turn_time_13", default: 3.0
    t.float "turn_time_14", default: 3.0
    t.float "turn_time_15", default: 3.0
    t.float "turn_time_16", default: 3.0
    t.float "turn_time_17", default: 3.0
    t.float "turn_time_18", default: 3.0
    t.float "turn_time_19", default: 3.0
    t.float "turn_time_20", default: 3.0
    t.integer "kitchen_pacing"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource_type_and_resource_id"
  end

  create_table "shift_notes", force: :cascade do |t|
    t.bigint "restaurant_id", null: false
    t.bigint "author_id", null: false
    t.datetime "shift_start_at", null: false
    t.text "note"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_shift_notes_on_author_id"
    t.index ["restaurant_id"], name: "index_shift_notes_on_restaurant_id"
  end

  create_table "users", force: :cascade do |t|
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.string "name", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "role_id"
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

  add_foreign_key "customers", "restaurants"
  add_foreign_key "floor_plan_tables", "floor_plans"
  add_foreign_key "floor_plans", "restaurants"
  add_foreign_key "reservation_plan_floor_plans", "floor_plans"
  add_foreign_key "reservation_plan_floor_plans", "reservation_plans"
  add_foreign_key "reservation_plans", "restaurants"
  add_foreign_key "reservations", "customers"
  add_foreign_key "reservations", "floor_plan_tables"
  add_foreign_key "reservations", "restaurants"
  add_foreign_key "reservations", "users", column: "canceled_by_id"
  add_foreign_key "shift_notes", "restaurants"
  add_foreign_key "shift_notes", "users", column: "author_id"
end
