class TestProblem < ApplicationRecord
  include ProgrammingLanguages

  validates :statement, :programming_language, :reference_solution, presence: true
  validates :programming_language, inclusion: { in: PROGRAMMING_LANGUAGES }

  has_many :test_suites, inverse_of: :test_problem
  has_many :solutions, inverse_of: :test_problem
end
