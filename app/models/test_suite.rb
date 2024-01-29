class TestSuite < ApplicationRecord
  GENERATED_BY = [
    GENERATED_BY_INSTRUCTOR = 'generated_by_instructor'.freeze,
    GENERATED_BY_LLM = 'generated_by_llm'.freeze
  ].freeze

  validates :generated_by, presence: true
  validates :generated_by, inclusion: { in: GENERATED_BY }

  belongs_to :problem, inverse_of: :test_suites
  has_many :test_cases, inverse_of: :test_suite, dependent: :destroy
  has_many :solution_test_suite_grades, inverse_of: :test_suite, dependent: :destroy
end
