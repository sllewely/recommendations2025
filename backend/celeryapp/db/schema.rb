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

ActiveRecord::Schema[8.0].define(version: 2025_10_29_181327) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pgcrypto"

  create_table "comments", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "numeric_commentable_id"
    t.string "commentable_type", null: false
    t.integer "numeric_user_id"
    t.text "body", null: false
    t.uuid "uuid", default: -> { "gen_random_uuid()" }, null: false
    t.uuid "user_id"
    t.uuid "commentable_id"
    t.index ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type"
    t.index ["numeric_commentable_id", "commentable_type"], name: "index_comments_on_numeric_commentable_id_and_commentable_type"
    t.index ["numeric_user_id"], name: "index_comments_on_numeric_user_id"
    t.index ["uuid"], name: "index_comments_on_uuid", unique: true
  end

  create_table "events", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "numeric_id", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title", null: false
    t.string "description"
    t.datetime "start_date_time", null: false
    t.string "address"
    t.string "url"
    t.string "event_type"
    t.integer "numeric_user_id"
    t.datetime "end_date_time"
    t.boolean "is_public", default: false
    t.uuid "user_id"
    t.index ["end_date_time"], name: "index_events_on_end_date_time"
    t.index ["event_type"], name: "index_events_on_event_type"
    t.index ["id"], name: "index_events_on_id", unique: true
    t.index ["is_public"], name: "index_events_on_is_public"
    t.index ["numeric_user_id"], name: "index_events_on_numeric_user_id"
    t.index ["start_date_time"], name: "index_events_on_start_date_time"
  end

  create_table "feed_items", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "feedable_id", null: false
    t.string "feedable_type", null: false
    t.uuid "user_id", null: false
    t.index ["user_id"], name: "index_feed_items_on_user_id"
  end

  create_table "friend_codes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "numeric_user_id"
    t.boolean "active", default: true
    t.string "token", null: false
    t.uuid "uuid", default: -> { "gen_random_uuid()" }, null: false
    t.uuid "user_id"
    t.index ["numeric_user_id"], name: "index_friend_codes_on_numeric_user_id"
    t.index ["token"], name: "index_friend_codes_on_token", unique: true
    t.index ["uuid"], name: "index_friend_codes_on_uuid", unique: true
  end

  create_table "friend_requests", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "numeric_user_id"
    t.integer "numeric_incoming_friend_id"
    t.uuid "uuid", default: -> { "gen_random_uuid()" }, null: false
    t.uuid "user_id"
    t.uuid "incoming_friend_id"
    t.index ["numeric_incoming_friend_id"], name: "index_friend_requests_on_numeric_incoming_friend_id"
    t.index ["numeric_user_id", "numeric_incoming_friend_id"], name: "idx_on_numeric_user_id_numeric_incoming_friend_id_334efb41da", unique: true
    t.index ["numeric_user_id"], name: "index_friend_requests_on_numeric_user_id"
    t.index ["user_id", "incoming_friend_id"], name: "index_friend_requests_on_user_id_and_incoming_friend_id", unique: true
    t.index ["uuid"], name: "index_friend_requests_on_uuid", unique: true
  end

  create_table "friendships", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "numeric_user_id"
    t.integer "numeric_friend_id"
    t.uuid "uuid", default: -> { "gen_random_uuid()" }, null: false
    t.uuid "user_id"
    t.uuid "friend_id"
    t.index ["numeric_user_id", "numeric_friend_id"], name: "index_friendships_on_numeric_user_id_and_numeric_friend_id", unique: true
    t.index ["numeric_user_id"], name: "index_friendships_on_numeric_user_id"
    t.index ["user_id", "friend_id"], name: "index_friendships_on_user_id_and_friend_id", unique: true
    t.index ["uuid"], name: "index_friendships_on_uuid", unique: true
  end

  create_table "groups", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
  end

  create_table "notifications", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "numeric_user_id"
    t.string "message", null: false
    t.boolean "active", default: true
    t.json "extras", default: {}
    t.integer "notif_type", null: false
    t.uuid "uuid", default: -> { "gen_random_uuid()" }, null: false
    t.uuid "user_id"
    t.index ["numeric_user_id"], name: "index_notifications_on_numeric_user_id"
    t.index ["uuid"], name: "index_notifications_on_uuid", unique: true
  end

  create_table "posts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "numeric_id", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "post_title"
    t.text "content"
    t.integer "numeric_user_id"
    t.uuid "user_id"
    t.index ["id"], name: "index_posts_on_id", unique: true
    t.index ["numeric_user_id"], name: "index_posts_on_numeric_user_id"
  end

  create_table "recommendations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "numeric_id", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title", null: false
    t.text "notes"
    t.string "media_type"
    t.string "who_recommended"
    t.integer "status", default: 0
    t.integer "rating", default: 0
    t.integer "numeric_user_id"
    t.string "url"
    t.uuid "user_id"
    t.index ["id"], name: "index_recommendations_on_id", unique: true
    t.index ["numeric_user_id", "title", "media_type"], name: "idx_on_numeric_user_id_title_media_type_02ab1e85f5", unique: true
    t.index ["numeric_user_id"], name: "index_recommendations_on_numeric_user_id"
    t.index ["user_id", "title", "media_type"], name: "index_recommendations_on_user_id_and_title_and_media_type", unique: true
  end

  create_table "rsvps", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "numeric_user_id"
    t.integer "numeric_event_id"
    t.integer "status", default: 0
    t.uuid "uuid", default: -> { "gen_random_uuid()" }, null: false
    t.uuid "user_id"
    t.uuid "event_id"
    t.index ["event_id"], name: "index_rsvps_on_event_id"
    t.index ["numeric_event_id"], name: "index_rsvps_on_numeric_event_id"
    t.index ["numeric_user_id", "numeric_event_id"], name: "index_rsvps_on_numeric_user_id_and_numeric_event_id", unique: true
    t.index ["numeric_user_id"], name: "index_rsvps_on_numeric_user_id"
    t.index ["user_id", "event_id"], name: "index_rsvps_on_user_id_and_event_id", unique: true
    t.index ["user_id", "numeric_event_id"], name: "index_rsvps_on_user_id_and_numeric_event_id", unique: true
    t.index ["uuid"], name: "index_rsvps_on_uuid", unique: true
  end

  create_table "sessions", force: :cascade do |t|
    t.integer "numeric_user_id"
    t.string "user_agent"
    t.string "ip_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "uuid", default: -> { "gen_random_uuid()" }, null: false
    t.uuid "user_id"
    t.index ["numeric_user_id"], name: "index_sessions_on_numeric_user_id"
    t.index ["uuid"], name: "index_sessions_on_uuid", unique: true
  end

  create_table "tags", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "tag", null: false
    t.uuid "uuid", default: -> { "gen_random_uuid()" }, null: false
    t.index ["tag"], name: "index_tags_on_tag"
    t.index ["uuid"], name: "index_tags_on_uuid", unique: true
  end

  create_table "user_groups", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "user_id", null: false
    t.uuid "group_id", null: false
    t.index ["group_id"], name: "index_user_groups_on_group_id"
    t.index ["user_id", "group_id"], name: "index_user_groups_on_user_id_and_group_id", unique: true
    t.index ["user_id"], name: "index_user_groups_on_user_id"
  end

  create_table "user_statuses", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "numeric_user_id"
    t.string "status", null: false
    t.uuid "uuid", default: -> { "gen_random_uuid()" }, null: false
    t.uuid "user_id"
    t.index ["numeric_user_id"], name: "index_user_statuses_on_numeric_user_id"
    t.index ["uuid"], name: "index_user_statuses_on_uuid", unique: true
  end

  create_table "user_tags", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "numeric_user_id"
    t.bigint "tag_id", null: false
    t.uuid "uuid", default: -> { "gen_random_uuid()" }, null: false
    t.uuid "user_id"
    t.index ["numeric_user_id", "tag_id"], name: "index_user_tags_on_numeric_user_id_and_tag_id", unique: true
    t.index ["numeric_user_id"], name: "index_user_tags_on_numeric_user_id"
    t.index ["tag_id"], name: "index_user_tags_on_tag_id"
    t.index ["user_id", "tag_id"], name: "index_user_tags_on_user_id_and_tag_id", unique: true
    t.index ["uuid"], name: "index_user_tags_on_uuid", unique: true
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "numeric_id", default: 0
    t.string "email", null: false
    t.string "password_digest", null: false
    t.boolean "verified", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.string "name"
    t.text "blurb"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["id"], name: "index_users_on_id", unique: true
  end

  add_foreign_key "comments", "users", on_delete: :cascade
  add_foreign_key "events", "users", on_delete: :cascade
  add_foreign_key "feed_items", "users"
  add_foreign_key "friend_codes", "users", on_delete: :cascade
  add_foreign_key "friend_requests", "users", on_delete: :cascade
  add_foreign_key "friendships", "users", on_delete: :cascade
  add_foreign_key "notifications", "users", on_delete: :cascade
  add_foreign_key "posts", "users", on_delete: :cascade
  add_foreign_key "recommendations", "users", on_delete: :cascade
  add_foreign_key "rsvps", "events", on_delete: :cascade
  add_foreign_key "rsvps", "users", on_delete: :cascade
  add_foreign_key "sessions", "users", on_delete: :cascade
  add_foreign_key "user_groups", "groups"
  add_foreign_key "user_groups", "users"
  add_foreign_key "user_statuses", "users", on_delete: :cascade
  add_foreign_key "user_tags", "tags"
  add_foreign_key "user_tags", "users", on_delete: :cascade
end
