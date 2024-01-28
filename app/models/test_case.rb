class TestCase < ApplicationRecord
  validates :expected_output, presence: true

  belongs_to :test_suite, inverse_of: :test_cases
end
