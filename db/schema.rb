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

ActiveRecord::Schema.define(:version => 20110604231631) do

  create_table "goals", :force => true do |t|
    t.string   "title"
    t.string   "description"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "shelved",     :default => false
  end

  add_index "goals", ["id"], :name => "index_goals_on_id"
  add_index "goals", ["user_id"], :name => "index_goals_on_user_id"

  create_table "habits", :force => true do |t|
    t.string   "description"
    t.string   "schedule_yaml"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "task_id"
  end

  create_table "tasks", :force => true do |t|
    t.string   "description"
    t.integer  "goal_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "complete"
    t.datetime "deadline"
    t.string   "kind",        :default => "plain"
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
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
