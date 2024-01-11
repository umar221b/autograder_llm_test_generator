module RunCodeServices
  class RunUnitTestsService < ApplicationService
    def initialize(llm_query)
      @llm_query = llm_query
    end

    def perform
      # TODO: run unit tests and drop failed ones here
      true
    end
  end
end