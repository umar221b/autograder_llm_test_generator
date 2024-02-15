require 'code_execution'

module RunCodeServices
  class RunMatchingOutputsService < ApplicationService
    def initialize(problem)
      @problem = problem
    end

    def perform
      case @problem.programming_language
      when LlmChatQuery::PROGRAMMING_LANGUAGE_C
        runner_class = CodeExecution::StandardCIORunner
      when LlmChatQuery::PROGRAMMING_LANGUAGE_PYTHON3
        runner_class = CodeExecution::StandardPython3IORunner
      else
        errors.add(:base, 'Unsupported programming language')
        return
      end

      code_runner = runner_class.new(@problem.reference_solution)
      tests = code_runner.generate_test_outputs

      tests.select { |test| test.error.blank? }

      @data = { tests: tests }

    end
  end
end