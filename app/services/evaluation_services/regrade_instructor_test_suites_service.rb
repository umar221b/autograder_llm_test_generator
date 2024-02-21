module EvaluationServices
  class RegradeInstructorTestSuitesService < ApplicationService
    def initialize(test_suite)
      @test_suite = test_suite
      @problem = @test_suite.problem
    end

    def perform
      case @problem.test_type
      when Problem::TEST_TYPE_MATCHING_OUTPUTS
        service = RegradeInstructorMatchingOutputsProblemsService.new(@test_suite)
      when Problem::TEST_TYPE_C_UNIT_TESTS_MATCHING
        service = RegradeInstructorCUnitTestsMatchingProblemsService.new(@test_suite)
      else
        errors.add(:base, 'Invalid problem type')
        return
      end

      errors.merge!(service.errors) unless service.run

      if service.data.present?
        results = service.data[:results]
        all_test_cases_results = []
        results.each do |result|
          all_test_cases_results += result.delete(:test_case_results)
        end
        unless SolutionTestSuiteGrade.upsert_all(results, unique_by: %i[test_suite_id solution_id])
          errors.add(:base, 'There was an issue saving the solution final result')
        end
        begin
          unless SolutionTestCaseResult.upsert_all(all_test_cases_results, unique_by: %i[solution_id test_case_id])
            errors.add(:base, "There was an issue saving the solution's test case results")
          end
        rescue PG::Error, PG::CharacterNotInRepertoire, ArgumentError, ActiveRecord::StatementInvalid => e
          puts "Before", all_test_cases_results
          puts e.message
          all_test_cases_results.each do |test_case_result|
            # some strings have invalid bytes that break in the db
            # we replace them with a message
            test_case_result[:output] = 'Original output had invalid bytes that cannot be represented'
            SolutionTestCaseResult.create(test_case_result)
          end
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