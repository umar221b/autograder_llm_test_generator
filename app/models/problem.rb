require 'hashing'

class Problem < ApplicationRecord
  include ProgrammingLanguages
  include TestTypes

  before_validation :update_reference_solution_digest, if: :will_save_change_to_reference_solution?

  validates :statement, :programming_language, :reference_solution, :reference_solution_digest, :test_type, presence: true
  validates :programming_language, inclusion: { in: PROGRAMMING_LANGUAGES }
  validates :test_type, inclusion: { in: TEST_TYPES }

  has_many :test_suites, inverse_of: :problem, dependent: :destroy
  has_many :solutions, inverse_of: :problem, dependent: :destroy
  has_many :llm_chat_queries, inverse_of: :problem, dependent: :destroy

  def test_type=(new_test_type)
    new_value = new_test_type
    case new_test_type
    when 'c_program'
      new_value = TEST_TYPE_MATCHING_OUTPUTS
    when 'c_function'
      new_value = TEST_TYPE_C_UNIT_TESTS
    end

    super(new_value)
  end

private

  def update_reference_solution_digest
    self.reference_solution_digest = Hashing.hash_code(reference_solution)
  end
end
