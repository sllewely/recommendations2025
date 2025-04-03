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

ActiveRecord::Schema[8.0].define(version: 2025_04_03_123614) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "events", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title", null: false
    t.string "description"
    t.datetime "start_date_time", null: false
    t.string "address"
    t.string "url"
    t.string "event_type"
    t.bigint "user_id", null: false
    t.datetime "end_date_time"
    t.boolean "is_public", default: false
    t.index ["event_type"], name: "index_events_on_event_type"
    t.index ["is_public"], name: "index_events_on_is_public"
    t.index ["start_date_time"], name: "index_events_on_start_date_time"
    t.index ["user_id"], name: "index_events_on_user_id"
  end

  create_table "post_recommendations", force: :cascade do |t|
    t.integer "post_id"
    t.integer "recommendation_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "posts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "post_title"
    t.text "content"
    t.bigint "user_id"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "recommendations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title", null: false
    t.text "notes"
    t.string "media_type"
    t.string "who_recommended"
    t.integer "status", default: 0
    t.integer "rating", default: 0
    t.bigint "user_id", null: false
    t.index ["user_id", "title", "media_type"], name: "index_recommendations_on_user_id_and_title_and_media_type", unique: true
    t.index ["user_id"], name: "index_recommendations_on_user_id"
  end

  create_table "rsvps", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.bigint "event_id", null: false
    t.integer "status", default: 0
    t.index ["event_id"], name: "index_rsvps_on_event_id"
    t.index ["user_id", "event_id"], name: "index_rsvps_on_user_id_and_event_id", unique: true
    t.index ["user_id"], name: "index_rsvps_on_user_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "user_agent"
    t.string "ip_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.boolean "verified", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.string "name"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "events", "users"
  add_foreign_key "posts", "users"
  add_foreign_key "recommendations", "users"
  add_foreign_key "rsvps", "events"
  add_foreign_key "rsvps", "users"
  add_foreign_key "sessions", "users"
end
