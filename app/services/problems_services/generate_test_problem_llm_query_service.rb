module ProblemsServices
  class GenerateProblemLlmQueryService < ApplicationService
    def initialize(problem)
      @problem = problem
    end

    def perform
      problem_description_service = LlmServices::GenerateDetailedProblemDescriptionService.new(
        @problem.problem_statement,
        @problem.reference_solution,
        @problem.programming_language
      )

      if problem_description_service.run
        @llm_details_query = problem_description_service.data[:llm_chat_query]
        problem_llm_query = ProblemLlmQuery.new(llm_query_id: @llm_details_query.id, problem_id: @problem.id)
        unless problem_llm_query.save
          errors.merge!(problem_llm_query.errors)
        end

        # no python problems in the testing problems so far
        test_type = 'matching_outputs'

        case test_type
        when LlmChatQuery::QUERY_TYPE_MATCHING_OUTPUTS
          service = LlmServices::GenerateMatchingOutputsService.new(
            @problem.problem_statement,
            @llm_details_query.query_json,
            @problem.reference_solution,
            @problem.programming_language
          )
        when LlmChatQuery::QUERY_TYPE_PYTHON3_UNIT_TESTS
          service = LlmServices::GeneratePythonUnitTestsService.new(
            @problem.problem_statement,
            @llm_details_query.query_json,
            @problem.reference_solution,
            @problem.programming_language
          )
        else
          service = nil
        end

        if service&.run
          @llm_tests_query = service.data[:llm_chat_query]
          problem_llm_query2 = ProblemLlmQuery.new(llm_query_id: @llm_tests_query.id, problem_id: @problem.id)
          unless problem_llm_query2.save
            errors.merge!(problem_llm_query2.errors)
          end
        end
      end
    end
  end
end