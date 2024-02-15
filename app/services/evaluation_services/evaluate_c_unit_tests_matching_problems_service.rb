require 'code_execution'
require 'c_test_parser'
require 'differ'

module EvaluationServices
  class EvaluateCUnitTestsMatchingProblemsService < ApplicationService

    PARALLEL_BATCH = 300
    SEPARATOR = "#<ab@17943918#@>#\n".freeze
    PRINT_SEPARATOR = 'printf("#<ab@17943918#@>#\n");'.freeze


    def initialize(test_suite)
      @test_suite = test_suite
      @problem = @test_suite.problem
    end

    def perform
      accepted_cases = @test_suite.test_cases.accepted.order(:id)
      all_tests = accepted_cases.map(&:test).join("\n#{PRINT_SEPARATOR}\n")
      llm_chat_query = @problem.llm_chat_queries.last
      parser = CTestParser.new(llm_chat_query.c_code)
      testing_code = parser.single_test_code(all_tests)


      test_inputs = [{ 'input' => '' }]
      optimal_outputs = accepted_cases.map { |test| test.expected_output.strip }
      solutions = @problem.solutions.not_evaluated(@test_suite.id).limit(PARALLEL_BATCH)

      if solutions.empty?
        puts "No more solutions to process"
        return
      end

      solution_grades = Parallel.map(solutions) do |solution|
        puts "Working on Solution ##{solution.id} for Test Suite ##{@test_suite.id}"

        solution_evaluation = { solution_id: solution.id, test_suite_id: @test_suite.id, grade: 0 }
        runner = CodeExecution::StandardCIORunner.new(
          testing_code, test_inputs,
          {
            'solution.c' => solution.code
          }
        )
        begin
          test_cases = runner.generate_test_outputs
          test_case = test_cases[0]

          if test_case.error.blank?
            case_outputs = test_case.output.split(SEPARATOR)
            case_outputs.each_with_index do |output, index|
              if Differ.no_diff?(output.strip, optimal_outputs[index])
                solution_evaluation[:grade] += 1
              end
            end
            solution_evaluation[:grade] /= accepted_cases.size.to_f
          end
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