require 'code_execution/runners/unit_test_runner'

module CodeExecution
  class Python3UnitTestRunner < UnitTestRunner
    FAILED_UNIT_TESTS_REGEX = /ERROR: (\S*)/

  private

    def prepare; end

    def run
      %x( python3 #{unit_test_file} 1>#{OUTPUT_FILE} 2>#{ERROR_FILE} )
    end

    def unit_test_file
      'tmp/unit_tests.py'.freeze
    end

    def solution_to_test_file
      'tmp/solution.py'.freeze
    end

    def extract_failed_tests
      errors = read_error
      errors.scan(FAILED_UNIT_TESTS_REGEX).flatten
    end
  end
end