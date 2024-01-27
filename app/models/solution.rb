class Solution < ApplicationRecord
  validates :student_unique_reference, :try, :code, presence: true
  validates :try, numericality: { greater_than: 0 }
  validates_uniqueness_of :try, scope: [:test_problem_id, :student_unique_reference]

  belongs_to :test_problem, inverse_of: :solutions
  has_many :solution_test_suite_grades, inverse_of: :solution
end
