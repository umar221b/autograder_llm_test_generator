module EvaluationServices
  class EvaluateOneSolutionService < ApplicationService
    def initialize(solution, test_suite, only_valid = false)
      @solution = solution
      @test_suite = test_suite
      @problem = @test_suite.problem
      @only_valid = only_valid
    end

    def perform
      case @test_suite.generated_by
      when TestSuite::GENERATED_BY_INSTRUCTOR_RUN_BY_US
        case @problem.test_type
        when Problem::TEST_TYPE_MATCHING_OUTPUTS
          service = RegradeInstructorMatchingOutputsProblemsService.new(@test_suite, @solution)
        when Problem::TEST_TYPE_C_UNIT_TESTS_MATCHING
          service = RegradeInstructorCUnitTestsMatchingProblemsService.new(@test_suite, @solution)
        else
          errors.add(:base, 'Invalid problem type')
          return
        end
      when TestSuite::GENERATED_BY_LLM
        case @problem.test_type
        when Problem::TEST_TYPE_MATCHING_OUTPUTS
          service = EvaluateMatchingOutputsProblemsService.new(@test_suite, @solution, @only_valid)
        when Problem::TEST_TYPE_C_UNIT_TESTS_MATCHING
          service = EvaluateCUnitTestsMatchingProblemsService.new(@test_suite, @solution, @only_valid)
        else
          errors.add(:base, 'Invalid problem type')
          return
        end
      end

      errors.merge!(service.errors) unless service.run

      if service.data.present?
        results = service.data[:results]
        all_test_cases_results = []
        results.each do |result|
          all_test_cases_results += result.delete(:test_case_results)
        end
        @data = {
          solution_test_suite_grades: results,
          solution_test_case_results: all_test_cases_results
        }
      else
        @data = nil
      end
    end
  end
end