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

ActiveRecord::Schema.define(version: 20160220025420) do

  create_table "betconditions", force: :cascade do |t|
    t.integer  "place_id",             limit: 4
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "name",                 limit: 255
    t.integer  "user_id",              limit: 4
    t.string   "mode",                 limit: 255
    t.text     "analyze_result_cache", limit: 65535
    t.text     "try_result_cache",     limit: 65535
  end

  create_table "horceresults", force: :cascade do |t|
    t.float    "odds",       limit: 24
    t.integer  "popularity", limit: 4
    t.integer  "horce_num",  limit: 4
    t.integer  "frame_num",  limit: 4
    t.integer  "ranking",    limit: 4
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.integer  "race_id",    limit: 4
    t.integer  "horce_id",   limit: 4
  end

  add_index "horceresults", ["popularity"], name: "index_horceresults_on_popularity", using: :btree

  create_table "horces", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "places", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "popconditions", force: :cascade do |t|
    t.integer  "popularity",      limit: 4
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.integer  "betcondition_id", limit: 4
    t.decimal  "odds_start",                precision: 10
    t.decimal  "odds_end",                  precision: 10
  end

  create_table "races", force: :cascade do |t|
    t.date     "date"
    t.integer  "race_num",   limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "place_id",   limit: 4
  end

  add_index "races", ["date"], name: "index_races_on_date", using: :btree
  add_index "races", ["place_id"], name: "index_races_on_place_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
