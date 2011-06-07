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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110602080503) do

  create_table "line_items", :force => true do |t|
    t.integer  "price"
    t.string   "xyz_name"
    t.integer  "order_id"
    t.integer  "qty"
    t.string   "discount_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orders", :force => true do |t|
    t.boolean  "status"
    t.string   "currency"
    t.string   "mode"
    t.integer  "amount"
    t.datetime "purchased_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payplug_notifications", :force => true do |t|
    t.text     "params"
    t.string   "gateway"
    t.string   "transaction_id"
    t.string   "notification_status", :default => ""
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end