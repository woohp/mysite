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

ActiveRecord::Schema.define(version: 20130914005050) do

  create_table "companies", force: true do |t|
    t.string   "name",       null: false
    t.string   "symbol",     null: false
    t.string   "cik",        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "filings", force: true do |t|
    t.integer  "company_id", null: false
    t.string   "sec_link"
    t.string   "category",   null: false
    t.datetime "date",       null: false
    t.text     "details"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "filings", ["company_id"], name: "index_filings_on_company_id", using: :btree

  create_table "todos", force: true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.text     "description"
    t.integer  "status_cd"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "todos", ["user_id"], name: "index_todos_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "username",         null: false
    t.string   "email"
    t.string   "crypted_password"
    t.string   "salt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
