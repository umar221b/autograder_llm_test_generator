class TestCase < ApplicationRecord
  validates :test, :expected_output, presence: true

  belongs_to :test_suite, inverse_of: :test_cases
end
