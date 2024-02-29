require 'code_execution'
require 'differ'

module EvaluationServices
  class EvaluateMatchingOutputsProblemsService < ApplicationService
    PARALLEL_BATCH = 15

    def initialize(test_suite, solution = nil, only_valid = false)
      @test_suite = test_suite
      @problem = test_suite.problem
      @solutions = solution.present? ? [solution] : nil
      @only_valid = only_valid
    end

    def perform
      accepted_cases = @test_suite.test_cases.accepted.order(:id)
      accepted_cases = accepted_cases.valid if @only_valid
      accepted_cases.load

      test_inputs = accepted_cases.map { |test| { 'input' => test.test } }
      optimal_outputs = accepted_cases.map { |test| test.expected_output }
      if @solutions.blank?
        @solutions = @problem.solutions.not_evaluated(@test_suite.id).order(:id).limit(PARALLEL_BATCH).load
      end

      if @solutions.empty?
        puts "No more solutions to process"
        @data = nil
        return
      end
      # solution_grades = Parallel.map(@solutions) do |solution|
      solution_grades = @solutions.map do |solution|
        puts "Working on Solution ##{solution.id} for Test Suite ##{@test_suite.id}"

        solution_evaluation = {
          solution_id: solution.id, test_suite_id: @test_suite.id,
          grade: 0
        }
        all_test_cases_results = []

        runner = CodeExecution::StandardCIORunner.new(solution.code, test_inputs, {}, solution.id)

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
          test_cases.each_with_index do |test_case, index|
            test_case_results = {
              solution_id: solution.id, test_case_id: accepted_cases[index].id,
              output: test_case.output, runtime_errors: ''
            }

            if test_case.error.present?
              test_case_results[:runtime_errors] = test_case.error
            elsif Differ.no_diff?(test_case.output, optimal_outputs[index])
                solution_evaluation[:grade] += 1
            end
            all_test_cases_results << test_case_results
          end
          solution_evaluation[:grade] /= accepted_cases.size.to_f
        end
        solution_evaluation[:test_case_results] = all_test_cases_results
        solution_evaluation
      end
      @data = { results: solution_grades }
    end
  end
end