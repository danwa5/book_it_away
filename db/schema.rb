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

ActiveRecord::Schema.define(version: 20130930035814) do

  create_table "authors", force: true do |t|
    t.string   "last_name"
    t.string   "first_name"
    t.date     "dob"
    t.string   "nationality"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "authors", ["last_name", "first_name"], name: "index_authors_on_last_name_and_first_name", unique: true

  create_table "books", force: true do |t|
    t.string   "isbn"
    t.string   "title"
    t.string   "publisher"
    t.integer  "pages"
    t.integer  "author_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "books", ["isbn"], name: "index_books_on_isbn", unique: true

  create_table "reviews", force: true do |t|
    t.decimal  "rating"
    t.text     "comments"
    t.integer  "likes",      default: 0
    t.integer  "dislikes",   default: 0
    t.integer  "book_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reviews", ["book_id", "created_at"], name: "index_reviews_on_book_id_and_created_at"
  add_index "reviews", ["user_id", "created_at"], name: "index_reviews_on_user_id_and_created_at"

  create_table "users", force: true do |t|
    t.string   "last_name"
    t.string   "first_name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",           default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["remember_token"], name: "index_users_on_remember_token"

end