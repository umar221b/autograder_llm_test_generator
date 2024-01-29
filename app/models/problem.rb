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

private

  def update_reference_solution_digest
    self.reference_solution_digest = Hashing.hash_code(reference_solution)
  end
end
