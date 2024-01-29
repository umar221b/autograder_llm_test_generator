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

ActiveRecord::Schema[7.0].define(version: 2024_01_29_150125) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "llm_chat_queries", force: :cascade do |t|
    t.text "problem_statement", null: false
    t.text "reference_solution", null: false
    t.string "reference_solution_digest", null: false
    t.string "programming_language", null: false
    t.string "ai_model", null: false
    t.float "temperature", null: false
    t.string "finish_reason"
    t.boolean "completed_response", default: false, null: false
    t.text "response"
    t.integer "input_tokens", null: false
    t.integer "output_tokens"
    t.string "query_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "problem_id", null: false
    t.index ["problem_id"], name: "index_llm_chat_queries_on_problem_id"
    t.index ["reference_solution_digest"], name: "index_llm_chat_queries_on_reference_solution_digest"
  end

  create_table "llm_chat_query_messages", force: :cascade do |t|
    t.string "role", null: false
    t.text "content", null: false
    t.bigint "llm_chat_query_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["llm_chat_query_id"], name: "index_llm_chat_query_messages_on_llm_chat_query_id"
  end

  create_table "problems", force: :cascade do |t|
    t.string "title", default: "Untitled Problem", null: false
    t.text "statement", null: false
    t.string "programming_language", null: false
    t.string "test_type", null: false
    t.text "reference_solution", null: false
    t.string "reference_solution_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reference_solution_digest"], name: "index_problems_on_reference_solution_digest"
  end

  create_table "solution_test_suite_grades", force: :cascade do |t|
    t.bigint "test_suite_id", null: false
    t.bigint "solution_id", null: false
    t.float "grade", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["solution_id"], name: "index_solution_test_suite_grades_on_solution_id"
    t.index ["test_suite_id", "solution_id"], name: "solution_test_suite_index"
    t.index ["test_suite_id"], name: "index_solution_test_suite_grades_on_test_suite_id"
  end

  create_table "solutions", force: :cascade do |t|
    t.bigint "problem_id", null: false
    t.string "student_unique_reference", null: false
    t.integer "try", null: false
    t.text "code", null: false
    t.text "code_digest", null: false
    t.datetime "submission_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code_digest"], name: "index_solutions_on_code_digest"
    t.index ["problem_id", "student_unique_reference", "try"], name: "unique_problem_solution_index", unique: true
    t.index ["problem_id"], name: "index_solutions_on_problem_id"
  end

  create_table "test_cases", force: :cascade do |t|
    t.bigint "test_suite_id", null: false
    t.text "test"
    t.text "expected_output", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["test_suite_id"], name: "index_test_cases_on_test_suite_id"
  end

  create_table "test_suites", force: :cascade do |t|
    t.bigint "problem_id", null: false
    t.string "generated_by", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["problem_id"], name: "index_test_suites_on_problem_id"
  end

  add_foreign_key "llm_chat_queries", "problems"
  add_foreign_key "llm_chat_query_messages", "llm_chat_queries"
  add_foreign_key "solution_test_suite_grades", "solutions"
  add_foreign_key "solution_test_suite_grades", "test_suites"
  add_foreign_key "solutions", "problems"
  add_foreign_key "test_cases", "test_suites"
  add_foreign_key "test_suites", "problems"
end
