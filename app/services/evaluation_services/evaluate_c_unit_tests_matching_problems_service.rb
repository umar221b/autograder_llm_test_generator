require 'code_execution'
require 'c_test_parser'
require 'differ'

module EvaluationServices
  class EvaluateCUnitTestsMatchingProblemsService < ApplicationService

    PARALLEL_BATCH = 15
    SEPARATOR = "#<ab@17943918#@>#\n".freeze
    PRINT_SEPARATOR = 'printf("#<ab@17943918#@>#\n");'.freeze


    def initialize(test_suite, solution = nil, only_valid = false)
      @test_suite = test_suite
      @problem = @test_suite.problem
      @solutions = solution.present? ? [solution] : nil
      @only_valid = only_valid
    end

    def perform
      accepted_cases = @test_suite.test_cases.accepted.order(:id)
      accepted_cases = accepted_cases.valid if @only_valid
      accepted_cases.load

      all_tests = accepted_cases.map(&:test).join("\n#{PRINT_SEPARATOR}\n")
      llm_chat_query = @problem.llm_chat_queries.last
      parser = CTestParser.new(llm_chat_query.c_code, @test_suite.random_seed)
      testing_code = parser.single_test_code(all_tests)

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

      # solution_grades = Parallel.map(@solutions) do |solution|
      solution_grades = @solutions.map do |solution|
        puts "Working on Solution ##{solution.id} for Test Suite ##{@test_suite.id}"

        solution_evaluation = {
          solution_id: solution.id, test_suite_id: @test_suite.id,
          grade: 0
        }

        all_test_cases_results = []
        runner = CodeExecution::StandardCIORunner.new(
          testing_code, test_inputs,
          {
            'solution.c' => solution.code
          },
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
  end
end