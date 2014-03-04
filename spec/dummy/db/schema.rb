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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20131101092408) do

  create_table "unified_payment_transactions", :force => true do |t|
    t.integer  "gateway_order_id"
    t.string   "gateway_order_status"
    t.string   "amount"
    t.string   "gateway_session_id"
    t.string   "url"
    t.string   "merchant_id"
    t.string   "currency"
    t.string   "order_description"
    t.string   "response_status"
    t.string   "response_description"
    t.string   "pan"
    t.string   "approval_code"
    t.text     "xml_response"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  add_index "unified_payment_transactions", ["gateway_order_id", "gateway_session_id"], :name => "order_session_index"
  add_index "unified_payment_transactions", ["response_status"], :name => "index_unified_payment_transactions_on_response_status"

end
