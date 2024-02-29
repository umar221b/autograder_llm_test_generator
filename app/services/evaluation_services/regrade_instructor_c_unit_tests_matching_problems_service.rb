require 'code_execution'
require 'differ'

module EvaluationServices
  class RegradeInstructorCUnitTestsMatchingProblemsService < ApplicationService

    PARALLEL_BATCH = 15
    SEPARATOR = "#<ab@17943918#@>#\n".freeze
    PRINT_SEPARATOR = 'printf("#<ab@17943918#@>#\n");'.freeze


    def initialize(test_suite, solution = nil)
      @test_suite = test_suite
      @problem = @test_suite.problem
      @solutions = solution.present? ? [solution] : nil
    end

    def perform
      accepted_cases = @test_suite.test_cases.accepted.order(:id).load
      all_tests = accepted_cases.map(&:test).map { |test| "{\n    #{test}\n}"}.join("\n#{PRINT_SEPARATOR}\n")

      sub_hash = {}
      testing_code = c_function_template
      sub_hash["{{ STUDENT_ANSWER }}"] = "{{ STUDENT_ANSWER }}"
      sub_hash["{{ EXTRA_CODE }}"] = @problem.extra_code || ""
      sub_hash["{{ TEST_CASES }}"] = all_tests
      regex = /{{ [A-Z_]+ }}/
      testing_code.gsub!(regex, sub_hash)

      test_inputs = [{ 'input' => '' }]
      optimal_outputs = accepted_cases.map { |test| test.expected_output }
      if @solutions.blank?
        @solutions = @problem.solutions.not_evaluated(@test_suite.id).order(:id).limit(PARALLEL_BATCH).load
      end

      if @solutions.empty?
        puts "No more solutions to process"
        @data = nil
        return
      end

      solution_grades = Parallel.map(@solutions) do |solution|
        puts "Working on Solution ##{solution.id} for Test Suite ##{@test_suite.id}"

        sub_hash = {}
        sub_hash["{{ STUDENT_ANSWER }}"] = solution.code
        student_code = testing_code.gsub(regex, sub_hash)

        solution_evaluation = {
          solution_id: solution.id, test_suite_id: @test_suite.id,
          grade: 0
        }

        all_test_cases_results = []

        runner = CodeExecution::StandardCIORunner.new(
          student_code, test_inputs, {},
          solution.id
        )

        compiled = false

        begin
          test_cases = runner.generate_test_outputs
          compiled = true
        rescue CodeExecution::PreparationError => e
          puts "Solution #{solution.id} did not compile, skipping.."
          puts e.message
          solution_evaluation[:grade] = -1
        end

        if compiled
          test_case = test_cases[0]
          error = ""

          begin
            if test_case.error.present?
              error = test_case.error
            else
              puts test_case.output
              case_outputs = test_case.output.split(SEPARATOR)
            end
          rescue Encoding::CompatibilityError, ArgumentError => e
            puts "Solution #{solution.id} produced invalid byte sequence.."
            puts e.message

            case_outputs = test_case.output.b.split(SEPARATOR)
          end

          optimal_outputs.each_with_index do |optimal_output, index|
            test_case_results = { solution_id: solution.id, test_case_id: accepted_cases[index].id, output: '', runtime_errors: '' }
            if error.blank?
              test_case_results[:output] = case_outputs[index]
              solution_evaluation[:grade] += 1 if Differ.no_diff?(case_outputs[index], optimal_output)
            else
              test_case_results[:runtime_errors] = error
            end
            all_test_cases_results << test_case_results
          end
          if errors.blank?
            solution_evaluation[:grade] /= accepted_cases.size.to_f
          end
        end
        solution_evaluation[:test_case_results] = all_test_cases_results
        solution_evaluation
      end
      @data = { results: solution_grades }
    end

  private

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