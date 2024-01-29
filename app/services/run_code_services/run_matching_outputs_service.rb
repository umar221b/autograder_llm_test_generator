require 'code_execution'

module RunCodeServices
  class RunMatchingOutputsService < ApplicationService
    def initialize(llm_query)
      @llm_chat_query = llm_query
    end

    def perform
      case @llm_chat_query.programming_language
      when LlmChatQuery::PROGRAMMING_LANGUAGE_C
        runner_class = CodeExecution::StandardCIORunner
      when LlmChatQuery::PROGRAMMING_LANGUAGE_PYTHON3
        runner_class = CodeExecution::StandardPython3IORunner
      else
        errors.add(:base, 'Unsupported programming language')
        return false
      end

      code_runner = runner_class.new(@llm_chat_query.reference_solution, @llm_chat_query.query_json)
      tests = code_runner.generate_test_outputs

      tests.select { |test| test.error.blank? }

      @data = { tests: tests }

      true
    end
  end
end