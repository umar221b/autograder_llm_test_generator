class TestSuite < ApplicationRecord
  GENERATED_BY = [
    GENERATED_BY_INSTRUCTOR = 'generated_by_instructor'.freeze,
    GENERATED_BY_LLM = 'generated_by_llm'.freeze
  ].freeze

  TEST_TYPES = [
    TEST_TYPE_C_PROGRAM = 'c_program'.freeze,
    TEST_TYPE_C_FUNCTION = 'c_function'.freeze
  ].freeze

  validates :generated_by, :test_type, presence: true
  validates :generated_by, inclusion: { in: GENERATED_BY }
  validates :test_type, inclusion: { in: TEST_TYPES }

  belongs_to :test_problem, inverse_of: :test_suites
  has_many :test_cases, inverse_of: :test_suite
  has_many :solution_test_suite_grades, inverse_of: :test_suite
end
