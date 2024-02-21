class SolutionTestCaseResult < ApplicationRecord
  belongs_to :solution
  belongs_to :test_case
end
