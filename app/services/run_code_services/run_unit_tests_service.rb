module RunCodeServices
  class RunUnitTestsService < ApplicationService
    def initialize(problem)
      @problem = problem
    end

    def perform
      # TODO: run unit tests and drop failed ones here
    end
  end
end