module RunCodeServices
  class RunCodeService < ApplicationService
    def initialize(llm_query)
      @llm_chat_query = llm_query
    end

    def perform
      case @llm_chat_query.test_type
      when LlmChatQuery::QUERY_TEMPLATE_MATCHING_OUTPUTS
        service = RunMatchingOutputsService.new(@llm_chat_query)
      when LlmChatQuery::QUERY_TYPE_PYTHON3_UNIT_TESTS
        service = RunPythonUnitTestsService.new(@llm_chat_query)
      else
        errors.add(:base, 'Invalid query type')
        return false
      end

      errors.merge!(service.errors) unless service.run

      @data = service.data

      true
    end
  end
end