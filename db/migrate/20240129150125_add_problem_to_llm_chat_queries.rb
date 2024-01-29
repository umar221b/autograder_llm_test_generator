class AddProblemToLlmChatQueries < ActiveRecord::Migration[7.0]
  def change
    add_reference :llm_chat_queries, :problem, null: false, foreign_key: true, index: true
  end
end
