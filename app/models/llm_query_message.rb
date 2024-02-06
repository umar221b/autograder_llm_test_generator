class LlmQueryMessage < ApplicationRecord
  ROLES = [ROLE_SYSTEM = 'system'.freeze, ROLE_USER = 'user'.freeze]

  validates :role, :content, presence: true
  validates :role, inclusion: { in: ROLES }

  belongs_to :llm_chat_query, inverse_of: :llm_query_messages
end
