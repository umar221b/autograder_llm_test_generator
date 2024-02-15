class AddLlmChatQueryToTestSuites < ActiveRecord::Migration[7.0]
  def change
    add_reference :test_suites, :llm_chat_query, null: true, index: true
  end
end
