class TestSuite < ApplicationRecord
  GENERATED_BY = [
    GENERATED_BY_INSTRUCTOR = 'generated_by_instructor'.freeze,
    GENERATED_BY_LLM = 'generated_by_llm'.freeze,
    GENERATED_BY_INSTRUCTOR_RUN_BY_US = 'generated_by_instructor_run_by_us'.freeze,
  ].freeze

  before_validation :set_random_seed, on: :create

  validates :generated_by, :random_seed, presence: true
  validates :generated_by, inclusion: { in: GENERATED_BY }

  belongs_to :problem, inverse_of: :test_suites
  belongs_to :llm_chat_query, optional: true, inverse_of: :test_suites
  has_many :test_cases, inverse_of: :test_suite, dependent: :destroy
  has_many :solution_test_suite_grades, inverse_of: :test_suite, dependent: :destroy

private

  def set_random_seed
    self.random_seed = rand(1_000_000_007)
  end
end
