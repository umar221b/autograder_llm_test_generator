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

      service = LlmServices::GenerateTestsService.new(@problem, @llm_details_query.query_json)

      unless service&.run
        puts "Failed to generate problem tests"
        errors.merge!(service.errors)
        return
      end

      true
    end
  end
end