require 'hashing'

class TestProblem < ApplicationRecord
  include ProgrammingLanguages

  validates :problem_statement, :programming_language, :reference_solution, :reference_solution_digest, presence: true
  validates :programming_language, inclusion: { in: PROGRAMMING_LANGUAGES }
  validates_uniqueness_of :reference_solution_digest, scope: :title, message: 'There is already a problem with the same title and reference solution'

  has_many :test_suites, inverse_of: :test_problem
  has_many :solutions, inverse_of: :test_problem

  before_validation :update_reference_solution_digest, if: :will_save_change_to_reference_solution?

private

  def update_reference_solution_digest
    self.reference_solution_digest = Hashing.hash_code(reference_solution)
  end
end
