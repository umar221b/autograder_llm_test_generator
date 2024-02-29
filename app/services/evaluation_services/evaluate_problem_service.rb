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
        all_test_cases_results = []
        results.each do |result|
          all_test_cases_results += result.delete(:test_case_results)
        end
        begin
          SolutionTestCaseResult.upsert_all(all_test_cases_results, unique_by: %i[solution_id test_case_id])
        rescue PG::Error, PG::CharacterNotInRepertoire, ArgumentError, ActiveRecord::StatementInvalid => e
          puts "Before", all_test_cases_results
          puts e.message
          all_test_cases_results.each do |test_case_result|
            # some strings have invalid bytes that break in the db
            # we replace them with a message if their insertion fails
            begin
              SolutionTestCaseResult.upsert(test_case_result, unique_by: %i[solution_id test_case_id])
            rescue PG::Error, PG::CharacterNotInRepertoire, ArgumentError, ActiveRecord::StatementInvalid => e
              test_case_result[:output] = test_case_result[:output].encode('UTF-8', :invalid => :replace, :undef => :replace)
              test_case_result[:output] = test_case_result[:output].gsub("\u0000", '')
              test_case_result[:output] += "\nOriginal output had invalid bytes that cannot be represented"
              SolutionTestCaseResult.upsert(test_case_result, unique_by: %i[solution_id test_case_id])
            end
          end
        end
        SolutionTestSuiteGrade.upsert_all(results, unique_by: %i[test_suite_id solution_id])
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