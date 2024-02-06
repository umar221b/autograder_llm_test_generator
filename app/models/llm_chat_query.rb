require 'json'
require 'hashing'

class LlmChatQuery < ApplicationRecord
  include ProgrammingLanguages

  QUERY_TYPES = [
    QUERY_TYPE_DETAILED_PROBLEM_STATEMENT = 'detailed_problem_statement'.freeze,
    QUERY_TYPE_MATCHING_OUTPUTS = 'matching_outputs'.freeze,
    QUERY_TYPE_UNIT_TESTS = 'unit_tests'.freeze,
  ].freeze

  PYTHON_CODE_REGEX = /`{3}python([\w]*)\n([\S\s]+?)\n`{3}/

  before_validation :update_reference_solution_digest, if: :will_save_change_to_reference_solution?

  validates :problem_statement, :reference_solution, :reference_solution_digest, :ai_model, :temperature, :query_type, presence: true
  validates :completed_response, inclusion: { in: [true, false] }
  validates :programming_language, inclusion: { in: PROGRAMMING_LANGUAGES }
  validates :query_type, inclusion: { in: QUERY_TYPES }

  validate :response_fields_exist, if: :completed_response

  belongs_to :problem, inverse_of: :llm_chat_queries
  has_many :llm_query_messages, inverse_of: :llm_chat_query, dependent: :destroy


  def is_detailed_problem_statement?
    query_type == QUERY_TYPE_DETAILED_PROBLEM_STATEMENT
  end

  def is_matching_outputs?
    query_type == QUERY_TYPE_MATCHING_OUTPUTS
  end

  def is_unit_tests?
    query_type == QUERY_TYPE_UNIT_TESTS
  end

  def query_json
    return nil unless is_detailed_problem_statement?

    JSON.parse(response)
  end

  def query_pretty_json
    json = query_json
    return json if json.nil?

    JSON.pretty_generate(json)
  end

  def python_code
    response.match(PYTHON_CODE_REGEX)
  end

  private

  def update_reference_solution_digest
    self.reference_solution_digest = Hashing.hash_code(reference_solution)
  end

  def response_fields_exist
    return if finish_reason.present? && response.present? && output_tokens.present? && input_tokens.present?

    errors.add(:completed_response, 'cannot be true because one or more of the response fields are blank')
  end
end
