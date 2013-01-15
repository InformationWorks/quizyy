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

ActiveRecord::Schema.define(:version => 20130115102326) do

  create_table "activity_logs", :force => true do |t|
    t.integer  "actor_id"
    t.string   "action"
    t.text     "activity"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "target_id"
  end

  create_table "attempt_details", :force => true do |t|
    t.integer  "attempt_id"
    t.integer  "question_id"
    t.integer  "option_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "user_input"
  end

  create_table "attempts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "quiz_id"
    t.boolean  "completed",           :default => false
    t.integer  "current_question_id"
    t.boolean  "is_current"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.integer  "current_section_id"
    t.integer  "current_time"
  end

  add_index "attempts", ["quiz_id"], :name => "index_attempts_on_quiz_id"
  add_index "attempts", ["user_id", "quiz_id"], :name => "index_attempts_on_user_id_and_quiz_id", :unique => true
  add_index "attempts", ["user_id"], :name => "index_attempts_on_user_id"

  create_table "cart_items", :force => true do |t|
    t.integer  "quiz_id"
    t.integer  "package_id"
    t.integer  "cart_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "cart_items", ["cart_id"], :name => "index_cart_items_on_cart_id"
  add_index "cart_items", ["package_id"], :name => "index_cart_items_on_package_id"
  add_index "cart_items", ["quiz_id"], :name => "index_cart_items_on_quiz_id"

  create_table "carts", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "carts", ["user_id"], :name => "index_carts_on_user_id"

  create_table "categories", :force => true do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "options", :force => true do |t|
    t.text     "content"
    t.boolean  "correct"
    t.integer  "question_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "sequence_no"
  end

  add_index "options", ["question_id"], :name => "index_options_on_question_id"

  create_table "orders", :force => true do |t|
    t.integer  "responseCode"
    t.text     "responseDescription"
    t.integer  "cart_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  create_table "package_quizzes", :force => true do |t|
    t.integer  "package_id"
    t.integer  "quiz_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "package_quizzes", ["package_id"], :name => "index_package_quizzes_on_package_id"
  add_index "package_quizzes", ["quiz_id"], :name => "index_package_quizzes_on_quiz_id"

  create_table "packages", :force => true do |t|
    t.string   "name"
    t.text     "desc"
    t.decimal  "price"
    t.integer  "position"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "questions", :force => true do |t|
    t.integer  "sequence_no"
    t.text     "instruction"
    t.text     "passage"
    t.text     "que_text"
    t.text     "sol_text"
    t.integer  "option_set_count"
    t.text     "que_image"
    t.text     "sol_image"
    t.string   "di_location"
    t.text     "quantity_a"
    t.text     "quantity_b"
    t.integer  "type_id"
    t.integer  "topic_id"
    t.integer  "section_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "questions", ["section_id"], :name => "index_questions_on_section_id"
  add_index "questions", ["topic_id"], :name => "index_questions_on_topic_id"
  add_index "questions", ["type_id"], :name => "index_questions_on_type_id"

  create_table "quiz_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "quiz_users", :force => true do |t|
    t.integer  "quiz_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "quiz_users", ["quiz_id"], :name => "index_quiz_users_on_quiz_id"
  add_index "quiz_users", ["user_id"], :name => "index_quiz_users_on_user_id"

  create_table "quizzes", :force => true do |t|
    t.string   "name"
    t.text     "desc"
    t.boolean  "random"
    t.integer  "quiz_type_id"
    t.integer  "category_id"
    t.integer  "topic_id"
    t.datetime "created_at",                                                     :null => false
    t.datetime "updated_at",                                                     :null => false
    t.boolean  "timed"
    t.decimal  "price",        :precision => 10, :scale => 2, :default => 0.0
    t.boolean  "published",                                   :default => false
    t.integer  "publisher_id"
    t.datetime "published_at"
    t.boolean  "approved",                                    :default => false
    t.integer  "approver_id"
    t.datetime "approved_at"
  end

  add_index "quizzes", ["approver_id"], :name => "index_quizzes_on_approver_id"
  add_index "quizzes", ["category_id"], :name => "index_quizzes_on_category_id"
  add_index "quizzes", ["publisher_id"], :name => "index_quizzes_on_publisher_id"
  add_index "quizzes", ["quiz_type_id"], :name => "index_quizzes_on_quiz_type_id"
  add_index "quizzes", ["topic_id"], :name => "index_quizzes_on_topic_id"

  create_table "role_users", :force => true do |t|
    t.integer  "role_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "role_users", ["role_id"], :name => "index_role_users_on_role_id"
  add_index "role_users", ["user_id"], :name => "index_role_users_on_user_id"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "section_types", :force => true do |t|
    t.string   "name"
    t.text     "instruction"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "sections", :force => true do |t|
    t.string   "name"
    t.integer  "sequence_no"
    t.integer  "quiz_id"
    t.integer  "section_type_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.text     "display_text"
  end

  add_index "sections", ["quiz_id"], :name => "index_sections_on_quiz_id"
  add_index "sections", ["section_type_id"], :name => "index_sections_on_section_type_id"

  create_table "topics", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "types", :force => true do |t|
    t.integer  "category_id"
    t.string   "code"
    t.string   "name"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "types", ["category_id"], :name => "index_types_on_category_id"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "full_name",              :default => "", :null => false
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "profile_image"
    t.integer  "credits",                :default => 0
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "visits", :force => true do |t|
    t.integer  "attempt_id"
    t.integer  "question_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "start"
    t.integer  "end"
  end

end
