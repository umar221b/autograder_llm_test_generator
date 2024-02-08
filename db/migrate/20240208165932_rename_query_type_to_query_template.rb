class RenameQueryTypeToQueryTemplate < ActiveRecord::Migration[7.0]
  def change
    rename_column :llm_chat_queries, :query_type, :query_template
  end
end
