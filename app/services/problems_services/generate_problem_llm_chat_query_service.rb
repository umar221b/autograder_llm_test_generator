module ProblemsServices
  class GenerateProblemLlmChatQueryService < ApplicationService
    def initialize(problem)
      @problem = problem
    end

    def perform
      problem_description_service = LlmServices::GenerateDetailedProblemDescriptionService.new(@problem)

      unless problem_description_service.run
        puts "Failed to generate problem detailed description"
        errors.merge!(problem_description_service.errors)
        return
      end

      @llm_details_query = problem_description_service.data[:llm_chat_query]

      # no python problems in the testing problems so far
      case @problem.test_type
      when Problem::TEST_TYPE_MATCHING_OUTPUTS
        service = LlmServices::GenerateMatchingOutputsService.new(@problem, @llm_details_query.query_json)
      when Problem::TEST_TYPE_PYTHON3_UNIT_TESTS
        service = LlmServices::GeneratePythonUnitTestsService.new(@problem, @llm_details_query.query_json)
      else
        service = nil
      end

      unless service&.run
        puts "Failed to generate problem tests"
        errors.merge!(service.errors)
        return
      end

      true
    end
  end
end