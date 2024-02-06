class CreateLlmChatQueries < ActiveRecord::Migration[7.0]
  def change
    create_table :llm_chat_queries do |t|
      t.text :problem_statement, null: false
      t.text :reference_solution, null: false
      t.string :reference_solution_digest, null: false, index: true
      t.string :programming_language, null: false
      t.string :ai_model, null: false
      t.float :temperature, null: false
      t.string :finish_reason
      t.boolean :completed_response, null: false, default: false
      t.text :response
      t.integer :input_tokens
      t.integer :output_tokens
      t.string :query_type, null: false

      t.timestamps
    end
  end
end
