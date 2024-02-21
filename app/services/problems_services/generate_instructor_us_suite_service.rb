require 'code_execution'
require 'c_test_parser'

module ProblemsServices
  class GenerateInstructorUsSuiteService < ApplicationService
    SEPARATOR = "#<ab@17943918#@>#\n".freeze
    PRINT_SEPARATOR = 'printf("#<ab@17943918#@>#\n");'.freeze

    def initialize(instructor_test_suite)
      @instructor_test_suite = instructor_test_suite
      @instructor_test_cases = @instructor_test_suite.test_cases.order(:id)
      @problem = @instructor_test_suite.problem
      @please_create = true
    end

    def perform
      if @please_create
        @test_suite = @problem.test_suites.new(generated_by: TestSuite::GENERATED_BY_INSTRUCTOR_RUN_BY_US)
        unless @test_suite.save
          errors.merge!(@test_suite.errors)
          return
        end
      end

      @reference_solution = @problem.reference_solution

      case @problem.test_type
      when Problem::TEST_TYPE_MATCHING_OUTPUTS
        handle_matching_outputs
      when Problem::TEST_TYPE_PYTHON3_UNIT_TESTS
        handle_python3_unit_tests
      when Problem::TEST_TYPE_C_UNIT_TESTS
        handle_c_unit_tests
      when Problem::TEST_TYPE_C_UNIT_TESTS_MATCHING
        handle_c_unit_tests_matching
      else
        errors.add(:base, 'Invalid problem test type')
        return
      end
    end

  private

    def handle_matching_outputs
      inputs_json = @instructor_test_cases.map{|test| { 'input' => test.test } }

      runner = CodeExecution::StandardCIORunner.new(@reference_solution, inputs_json)
      test_cases = runner.generate_test_outputs

      test_cases.each do |test_case|
        puts test_case
        puts "================"
        if @please_create
          @test_suite.test_cases.build(test: test_case.input, expected_output: test_case.output)
        end
      end

      if @please_create
        unless @test_suite.save
          errors.merge!(@test_suite.errors)
          @test_suite.test_cases.each { |test_case| errors.merge!(test_case.errors) }
          return
        end
      end
    end

    def handle_python3_unit_tests; end

    def handle_c_unit_tests; end

    def handle_c_unit_tests_matching
      all_tests = @instructor_test_cases.map{|test| "{\n #{test.test}\n}"}.join("\n#{PRINT_SEPARATOR}\n")

      sub_hash = {}
      testing_code = c_function_template
      sub_hash["{{ EXTRA_CODE }}"] = @problem.extra_code || ""
      sub_hash["{{ STUDENT_ANSWER }}"] = @reference_solution
      sub_hash["{{ TEST_CASES }}"] = all_tests

      regex = /{{ [A-Z_]+ }}/
      testing_code.gsub!(regex, sub_hash)
      runner = CodeExecution::StandardCIORunner.new(testing_code, [{ 'input': ''}])
      test_cases = runner.generate_test_outputs
      test_case = test_cases[0]
      case_outputs = test_case.output.split(SEPARATOR)
      case_outputs.each_with_index do |output, index|
        if @please_create
          @test_suite.test_cases.build(test: @instructor_test_cases[index].test, expected_output: output)
        end
      end

      if @please_create
        unless @test_suite.save
          errors.merge!(@test_suite.errors)
          @test_suite.test_cases.each { |test_case| errors.merge!(test_case.errors) }
        end
      end
    end

    def c_function_template
      <<-TEXT
      #include <stdio.h>
      #include <stdlib.h>
      #include <ctype.h>
      #include <string.h>
      #include <stdbool.h>
      #include <math.h>
      
      {{ EXTRA_CODE }}

      {{ STUDENT_ANSWER }}

      int main() {
        {{ TEST_CASES }}
        return 0;
      }
      TEXT
    end
  end
end