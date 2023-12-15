# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_12_13_201957) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "llm_queries", force: :cascade do |t|
    t.text "problem_statement", null: false
    t.text "instructor_solution", null: false
    t.string "instructor_solution_digest", null: false
    t.string "ai_model", null: false
    t.float "temperature", null: false
    t.string "finish_reason"
    t.boolean "completed_response", default: false, null: false
    t.text "response"
    t.integer "input_tokens", null: false
    t.integer "output_tokens"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["instructor_solution_digest"], name: "index_llm_queries_on_instructor_solution_digest"
  end

  create_table "llm_query_messages", force: :cascade do |t|
    t.string "role", null: false
    t.text "content", null: false
    t.bigint "llm_query_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["llm_query_id"], name: "index_llm_query_messages_on_llm_query_id"
  end

  add_foreign_key "llm_query_messages", "llm_queries"
end
