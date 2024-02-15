module RunCodeServices
  class RunCodeService < ApplicationService
    def initialize(test_suite, code, test_type)
      @test_suite = test_suite
      @code = code
      @test_type = test_type
    end

    def perform
      case @problem.test_type
      when Problem::TEST_TYPE_MATCHING_OUTPUTS, Problem::TEST_TYPE_C_UNIT_TESTS_MATCHING
        service = RunMatchingOutputsService.new(@problem)
      when Problem::TEST_TYPE_PYTHON3_UNIT_TESTS # TODO: not working yet
        service = RunUnitTestsService.new(@problem)
      else
        errors.add(:base, 'Invalid problem type')
        return false
      end

      errors.merge!(service.errors) unless service.run

      @data = service.data

    end
  end
end