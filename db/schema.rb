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

ActiveRecord::Schema.define(version: 20170930184546) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "companies", force: true do |t|
    t.string   "company_name"
    t.integer  "company_number"
    t.string   "company_type"
    t.hstore   "address"
    t.hstore   "accounts"
    t.boolean  "overdue"
    t.boolean  "has_charges"
    t.boolean  "has_insolvency_history"
    t.string   "jurisdiction"
    t.datetime "date_of_creation"
    t.boolean  "company_status"
    t.datetime "last_made_up_to"
    t.text     "sic_codes",              default: [], array: true
    t.boolean  "can_file"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
