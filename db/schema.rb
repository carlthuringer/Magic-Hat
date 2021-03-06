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

ActiveRecord::Schema.define(:version => 20111015184334) do

  create_table "completions", :force => true do |t|
    t.integer  "task_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "time"
  end

  add_index "completions", ["task_id"], :name => "index_completions_on_task_id"

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "default"
  end

  create_table "invitations", :force => true do |t|
    t.integer  "group_id"
    t.string   "user_email"
    t.string   "secure_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "memberships", :force => true do |t|
    t.integer "group_id"
    t.integer "user_id"
  end

  create_table "tasks", :force => true do |t|
    t.string   "description"
    t.integer  "goal_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deadline"
    t.string   "kind",          :default => "plain"
    t.integer  "habit_id"
    t.text     "schedule_yaml"
    t.integer  "group_id"
    t.integer  "user_id"
  end

  add_index "tasks", ["goal_id"], :name => "index_tasks_on_goal_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "encrypted_password"
    t.string   "salt"
    t.boolean  "admin",              :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "time_zone"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
