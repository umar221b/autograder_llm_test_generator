require 'hashing'

class Solution < ApplicationRecord
  before_validation :update_code_digest, if: :will_save_change_to_code?

  validates :student_unique_reference, :try, :code, :code_digest, presence: true
  validates :try, numericality: { greater_than: 0 }
  validates_uniqueness_of :try, scope: [:problem_id, :student_unique_reference]

  belongs_to :problem, inverse_of: :solutions
  has_many :solution_test_suite_grades, inverse_of: :solution, dependent: :destroy

  # gets solutions that do not have records in "solution_test_suite_grades" for the specified test_suite
  scope :not_evaluated, ->(test_suite_id) { joins("LEFT OUTER JOIN solution_test_suite_grades ON solutions.id = solution_test_suite_grades.solution_id AND solution_test_suite_grades.test_suite_id = #{test_suite_id}").where("solution_test_suite_grades.id is NULL") }
private

  def update_code_digest
    self.code_digest = Hashing.hash_code(code)
  end
end
