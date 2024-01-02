class LlmQuery < ApplicationRecord
  validates :problem_statement, :instructor_solution, :instructor_solution_digest, :ai_model, :temperature, :input_tokens, presence: true
  validates :completed_response, inclusion: { in: [true, false] }

  validate :response_fields_exist, if: :completed_response

  has_many :llm_query_messages, inverse_of: :llm_query

  def code
    code_regex = /`{3}([\w]*)\n([\S\s]+?)\n`{3}/
    content.match(code_regex)
  end

  private

  def response_fields_exist
    return if finish_reason.present? && response.present? && output_tokens.present?

    errors.add(:completed_response, 'cannot be true because one or more of the response fields are blank')
  end
end
