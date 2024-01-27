class SolutionTestSuiteGrade < ApplicationRecord
  validates :grade, presence: true, numericality: { greater_than_or_equal_to: 0 }

  belongs_to :test_suite, inverse_of: :solution_test_suite_grades
  belongs_to :solution, inverse_of: :solution_test_suite_grades
end
