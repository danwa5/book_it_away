class SquashedMigration < ActiveRecord::Migration
  def change
  create_table "authors", force: true do |t|
    t.string   "last_name"
    t.string   "first_name"
    t.date     "dob"
    t.string   "nationality"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "authors", ["last_name", "first_name"], name: "index_authors_on_last_name_and_first_name", unique: true, using: :btree

  create_table "books", force: true do |t|
    t.string   "isbn"
    t.string   "title"
    t.string   "publisher"
    t.date     "published_date"
    t.integer  "pages"
    t.integer  "author_id"
    t.string   "slug"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "books", ["isbn"], name: "index_books_on_isbn", unique: true, using: :btree

  create_table "books_categories", id: false, force: true do |t|
    t.integer "book_id",    null: false
    t.integer "category_id", null: false
  end

  add_index "books_categories", ["book_id", "category_id"], name: "index_books_categories_on_book_id_and_category_id", unique: true, using: :btree

  create_table "friendly_id_slugs", force: true do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

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

  add_index "reviews", ["book_id", "created_at"], name: "index_reviews_on_book_id_and_created_at", using: :btree
  add_index "reviews", ["user_id", "created_at"], name: "index_reviews_on_user_id_and_created_at", using: :btree

  create_table "categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "username",                        null: false
    t.string   "last_name",                       null: false
    t.string   "first_name",                      null: false
    t.string   "email",                           null: false
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",           default: false
    t.boolean  "email_confirmed", default: false
    t.string   "confirm_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree


  end
end
