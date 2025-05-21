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

ActiveRecord::Schema[8.0].define(version: 2025_05_14_105138) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "journey_type", ["frequently_routed", "infrequently_routed", "test_routing"]
  create_enum "run_mode", ["driving", "test_driving"]

  create_table "default_timings", id: :serial, force: :cascade do |t|
    t.string "timing", null: false
    t.check_constraint "id = 1", name: "default_timings_id_check"
  end

  create_table "journey_runs", force: :cascade do |t|
    t.bigint "journey_id", null: false
    t.bigint "run_id", null: false
    t.integer "duration", null: false
    t.integer "duration_in_traffic"
    t.integer "distance", null: false
    t.jsonb "overview_polyline", null: false
    t.datetime "created_at"
    t.jsonb "congestion_numeric"
    t.text "incidents"
    t.index ["created_at"], name: "index_journey_runs_on_created_at"
    t.index ["journey_id"], name: "journey_runs_journey_id"
    t.index ["run_id"], name: "journey_runs_run_id"
  end

  create_table "journeys", force: :cascade do |t|
    t.bigint "ltn_id", null: false
    t.decimal "origin_lat", precision: 11, scale: 8, null: false
    t.decimal "origin_lng", precision: 11, scale: 8, null: false
    t.decimal "dest_lat", precision: 11, scale: 8, null: false
    t.decimal "dest_lng", precision: 11, scale: 8, null: false
    t.boolean "disabled", default: false, null: false
    t.decimal "waypoint_lat", precision: 11, scale: 8
    t.decimal "waypoint_lng", precision: 11, scale: 8
    t.enum "type", default: "test_routing", null: false, enum_type: "journey_type"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "origin_id"
    t.bigint "point_of_interest_id"
    t.index ["ltn_id"], name: "journeys_ltn_id", where: "(NOT disabled)"
    t.index ["origin_id"], name: "index_journeys_on_origin_id"
    t.index ["point_of_interest_id", "origin_id"], name: "index_journeys_on_origin_and_poi", unique: true
    t.index ["type"], name: "journeys_type"
    t.check_constraint "waypoint_lat IS NULL AND waypoint_lng IS NULL OR waypoint_lat IS NOT NULL AND waypoint_lng IS NOT NULL", name: "both_or_neither_waypoints"
  end

  create_table "ltns", force: :cascade do |t|
    t.string "scheme_name", null: false
    t.bigint "user_id"
    t.float "default_lat"
    t.float "default_lng"
    t.index ["user_id"], name: "index_ltns_on_user_id"
  end

  create_table "origins", force: :cascade do |t|
    t.bigint "ltn_id", null: false
    t.float "lat", null: false
    t.float "lng", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ltn_id"], name: "index_origins_on_ltn_id"
  end

  create_table "point_of_interests", force: :cascade do |t|
    t.bigint "ltn_id", null: false
    t.float "lat", null: false
    t.float "lng", null: false
    t.string "name", null: false
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ltn_id"], name: "index_point_of_interests_on_ltn_id"
  end

  create_table "runs", force: :cascade do |t|
    t.bigint "ltn_id", null: false
    t.datetime "created_at", null: false
    t.datetime "finished_at"
    t.enum "mode", default: "driving", null: false, enum_type: "run_mode"
    t.index ["ltn_id"], name: "runs_ltn_id"
    t.index ["mode"], name: "runs_mode"
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
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "journey_runs", "journeys", name: "journey_runs_journey_id"
  add_foreign_key "journey_runs", "runs", name: "journey_runs_run_id"
  add_foreign_key "journeys", "ltns", name: "journeys_ltn_id"
  add_foreign_key "journeys", "origins", on_delete: :nullify
  add_foreign_key "journeys", "point_of_interests", on_delete: :nullify
  add_foreign_key "ltns", "users"
  add_foreign_key "origins", "ltns"
  add_foreign_key "point_of_interests", "ltns"
  add_foreign_key "runs", "ltns", name: "runs_ltn_id"
end
