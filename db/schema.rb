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

ActiveRecord::Schema.define(:version => 20130722013752) do

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "authentications", :force => true do |t|
    t.integer  "user_id"
    t.string   "uid",        :null => false
    t.string   "provider",   :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "token"
  end

  add_index "authentications", ["user_id"], :name => "index_authentications_on_user_id"

  create_table "hubs", :force => true do |t|
    t.string   "group_name"
    t.text     "description"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "location_id"
    t.string   "formatted_location"
  end

  add_index "hubs", ["formatted_location", "group_name"], :name => "index_hubs_on_formatted_location_and_group_name", :unique => true

  create_table "proposals", :force => true do |t|
    t.string   "statement"
    t.integer  "user_id"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.integer  "votes_count", :default => 0
    t.string   "ancestry"
    t.integer  "created_by"
    t.integer  "hub_id"
  end

  add_index "proposals", ["ancestry"], :name => "index_positions_on_ancestry"
  add_index "proposals", ["hub_id"], :name => "index_proposals_on_hub_id"
  add_index "proposals", ["user_id"], :name => "index_proposals_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => ""
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "name"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "votes", :force => true do |t|
    t.integer  "proposal_id"
    t.text     "comment"
    t.integer  "user_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "ip_address"
  end

  add_index "votes", ["proposal_id", "user_id"], :name => "index_votes_on_proposal_id_and_user_id"
  add_index "votes", ["proposal_id"], :name => "index_votes_on_proposal_id"
  add_index "votes", ["user_id"], :name => "index_votes_on_user_id"

end
