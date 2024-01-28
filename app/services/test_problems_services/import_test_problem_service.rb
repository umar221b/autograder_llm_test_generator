require 'code_runner'

module TestProblemsServices
  class ImportTestProblemService < ApplicationService
    def initialize(problem_file)
      @problem_file = problem_file
    end

    def perform
      full_file_path = "test_problems/problems/#{@problem_file}"
      unless File.file?(full_file_path)
        errors.add(:base, "File #{full_file_path} does not exist.")
        return false
      end

      test_problems = []
      parser = CodeRunner::Parser.new(full_file_path)
      parser.questions.each do |question|
        test_problem = TestProblem.new(
          title: question.problem_title, problem_statement: question.problem_statement,
          programming_language: question.programming_language, reference_solution: question.reference_solution
        )

        test_suite = test_problem.test_suites.build(
          generated_by: TestSuite::GENERATED_BY_INSTRUCTOR, test_type: question.problem_type
        )

        test_suite.test_cases.build(
          question.test_cases.map { |test_case| { test: test_case.test, expected_output: test_case.output } }
        )

        unless test_problem.save
          errors.add(:base, "Could not add problem: #{question.problem_title} from file #{@problem_file}")
          errors.merge!(test_problem.errors)
          errors.merge!(test_suite)
          test_suite.test_cases.each { |test_case| errors.merge!(test_case.errors) }

          next
        end

        test_problems << test_problem
      end

      @data[:test_problem] = test_problems[0] # assume each moodle export only has 1 problem for now
      true

    end
  end
end