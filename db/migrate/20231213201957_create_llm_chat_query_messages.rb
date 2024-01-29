class CreateLlmChatQueryMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :llm_chat_query_messages do |t|
      t.string :role, null: false
      t.text :content, null: false
      t.references :llm_chat_query, null: false, foreign_key: true, index: true

      t.timestamps
    end
  end
end
