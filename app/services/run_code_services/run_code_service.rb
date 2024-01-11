module RunCodeServices
  class RunCodeService < ApplicationService
    def initialize(llm_query)
      @llm_query = llm_query
    end

    def perform
      case @llm_query.query_type
      when LlmQuery::QUERY_TYPE_MATCHING_OUTPUTS
        service = RunMatchingOutputsService.new(@llm_query)
      when LlmQuery::QUERY_TYPE_UNIT_TESTS
        service = RunUnitTestsService.new(@llm_query)
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