class LlmQueryMessage < ApplicationRecord
  belongs_to :llm_query, inverse_of: :llm_query_messages
end
