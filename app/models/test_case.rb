class TestCase < ApplicationRecord
  validates :reference_solution_errors, presence: true, if: -> { rejected }

  belongs_to :test_suite, inverse_of: :test_cases

  scope :accepted, -> { where(rejected: false) }
  scope :valid, -> { where(bad: false) }

  has_many :solution_test_case_results, inverse_of: :test_case, dependent: :destroy
end
