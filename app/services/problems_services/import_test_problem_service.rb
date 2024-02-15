require 'code_runner'

module ProblemsServices
  class ImportTestProblemService < ApplicationService
    def initialize(problem_file)
      @problem_file = problem_file
    end

    def perform
      full_file_path = "test_problems/problems/#{@problem_file}.xml"
      unless File.file?(full_file_path)
        errors.add(:base, "File #{full_file_path} does not exist.")
        return
      end

      parser = CodeRunner::Parser.new(full_file_path)
      question = parser.questions[0] # assumes each export has 1 quesiton only

      problem = Problem.new(
        title: question.problem_title, statement: question.problem_statement,
        programming_language: question.programming_language, reference_solution: question.reference_solution,
        test_type: question.problem_type
      )

      test_suite = problem.test_suites.build(generated_by: TestSuite::GENERATED_BY_INSTRUCTOR)

      test_suite.test_cases.build(
        question.test_cases.map { |test_case| { test: test_case.test, expected_output: test_case.output } }
      )

      unless problem.save
        errors.add(:base, "Could not save problem: #{question.problem_title} from file #{@problem_file}")
        errors.merge!(problem.errors)
        errors.merge!(test_suite.errors)
        test_suite.test_cases.each { |test_case| errors.merge!(test_case.errors) }
        return
      end

      @data = { test_suite: test_suite }
    end
  end
end