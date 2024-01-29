require "active_support/concern"

module TestTypes
  extend ActiveSupport::Concern

  TEST_TYPES = [
    TEST_TYPE_MATCHING_OUTPUTS = 'matching_outputs'.freeze,
    TEST_TYPE_PYTHON3_UNIT_TESTS = 'python3_unit_tests'.freeze,
    TEST_TYPE_C_UNIT_TESTS = 'c_unit_tests'.freeze
  ]

  included do
  end

  class_methods do
  end
end
