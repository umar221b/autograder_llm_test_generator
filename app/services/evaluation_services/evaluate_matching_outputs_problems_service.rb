require 'code_execution'
require 'differ'

module EvaluationServices
  class EvaluateMatchingOutputsProblemsService < ApplicationService
    PARALLEL_BATCH = 300

    def initialize(test_suite)
      @test_suite = test_suite
      @problem = test_suite.problem
    end

    def perform
      accepted_cases = @test_suite.test_cases.accepted.order(:id)
      test_inputs = accepted_cases.map { |test| { 'input' => test.test } }
      optimal_outputs = accepted_cases.map { |test| test.expected_output.strip }
      solutions = @problem.solutions.not_evaluated(@test_suite.id).limit(PARALLEL_BATCH)
      if solutions.empty?
        puts "No more solutions to process"
        @data = { results: [] }
        return
      end

      solution_grades = Parallel.map(solutions) do |solution|
        puts "Working on Solution ##{solution.id} for Test Suite ##{@test_suite.id}"

        solution_evaluation = { solution_id: solution.id, test_suite_id: @test_suite.id, grade: 0 }
        runner = CodeExecution::StandardCIORunner.new(solution.code, test_inputs)
        begin
          test_cases = runner.generate_test_outputs
          test_cases.each_with_index do |test_case, index|
            next if test_case.error.present?


            next unless Differ.no_diff?(test_case.output.strip, optimal_outputs[index])

            solution_evaluation[:grade] += 1
          end
          solution_evaluation[:grade] /= accepted_cases.size.to_f
        rescue CodeExecution::PreparationError => e
          puts "Solution #{solution.id} did not compile, skipping.."
          solution_evaluation[:grade] = -1
        rescue Encoding::CompatibilityError, ArgumentError => e
          puts "Solution #{solution.id} produced invalid byte sequence.."
          puts e.message
        end
        solution_evaluation
      end
      @data = { results: solution_grades }
    end
  end
end