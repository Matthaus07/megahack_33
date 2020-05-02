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

ActiveRecord::Schema.define(version: 20200501232103) do

  create_table "enterprises", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "CNPJ"
    t.string "username"
    t.string "password_hash"
    t.string "name"
    t.string "session_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "products", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "description"
    t.decimal "price", precision: 10
    t.string "photo_url"
    t.integer "quantity"
    t.datetime "deleted_at"
    t.integer "small_business_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "small_businesses", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "CNPJ"
    t.string "username"
    t.string "password_hash"
    t.string "name"
    t.string "session_token"
    t.string "street"
    t.string "CEP"
    t.string "city"
    t.string "state"
    t.string "st_number"
    t.decimal "average_rating", precision: 10, default: "5"
    t.decimal "financial_rating", precision: 10, default: "5"
    t.string "address_observation"
    t.integer "total_ratings", default: 0
    t.string "category"
    t.string "photo_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "username"
    t.string "password_hash"
    t.string "CPF"
    t.string "session_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "street"
    t.string "CEP"
    t.string "city"
    t.string "state"
    t.string "st_number"
    t.string "address_observation"
  end

end
