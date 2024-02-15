module EvaluationServices
  class EvaluateProblemService < ApplicationService
    def initialize(test_suite)
      @test_suite = test_suite
      @problem = @test_suite.problem
    end

    def perform
      case @problem.test_type
      when Problem::TEST_TYPE_MATCHING_OUTPUTS
        service = EvaluateMatchingOutputsProblemsService.new(@test_suite)
      when Problem::TEST_TYPE_C_UNIT_TESTS_MATCHING
        service = EvaluateCUnitTestsMatchingProblemsService.new(@test_suite)
      else
        errors.add(:base, 'Invalid problem type')
        return
      end

      errors.merge!(service.errors) unless service.run

      if service.data.present?
        results = service.data[:results]
        unless SolutionTestSuiteGrade.create(results)
          errors.add(:base, 'There was an issue evaluating the solutions')
          errors.add(:base, service.errors.full_messages.join(', and '))
        end
        @data = service.data
      end
    end
  end
end