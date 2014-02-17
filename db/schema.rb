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

ActiveRecord::Schema.define(version: 20131203045610) do

  create_table "bookings", force: true do |t|
    t.integer  "resource_id"
    t.datetime "start_date"
    t.datetime "end_date"
    t.string   "status"
    t.string   "user"
  end

  add_index "bookings", ["end_date"], name: "index_bookings_on_end_date"
  add_index "bookings", ["start_date"], name: "index_bookings_on_start_date"

  create_table "resources", force: true do |t|
    t.string "name"
    t.text   "description"
  end

end
