class CreateLlmQueries < ActiveRecord::Migration[7.0]
  def change
    create_table :llm_queries do |t|
      t.text :problem_statement, null: false
      t.text :instructor_solution, null: false
      t.string :instructor_solution_digest, null: false, index: true
      t.string :ai_model, null: false
      t.float :temperature, null: false
      t.string :finish_reason
      t.boolean :completed_response, null: false, default: false
      t.text :response
      t.integer :input_tokens, null: false
      t.integer :output_tokens
      t.string :query_type, null: false

      t.timestamps
    end
  end
end
