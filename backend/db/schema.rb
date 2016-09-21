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

ActiveRecord::Schema.define(version: 20160909141554) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "games", force: :cascade do |t|
    t.integer  "results_count",   default: 0
    t.integer  "questions_count", default: 0
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "questions", force: :cascade do |t|
    t.integer  "game_id"
    t.string   "type"
    t.string   "title"
    t.json     "body"
    t.integer  "correct_count", default: 0
    t.integer  "wrong_count",   default: 0
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.index ["game_id"], name: "index_questions_on_game_id", using: :btree
  end

  create_table "results", force: :cascade do |t|
    t.integer  "game_id"
    t.string   "name"
    t.integer  "correct_count"
    t.integer  "score"
    t.json     "answers"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "organisation"
    t.integer  "incorrect_count", default: 0
    t.index ["game_id"], name: "index_results_on_game_id", using: :btree
  end

  add_foreign_key "questions", "games"
  add_foreign_key "results", "games"
end
