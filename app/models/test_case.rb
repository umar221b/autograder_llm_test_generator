class TestCase < ApplicationRecord
  validates :reference_solution_errors, presence: true, if: -> { rejected }

  belongs_to :test_suite, inverse_of: :test_cases

  scope :accepted, -> { where(rejected: false) }
end
