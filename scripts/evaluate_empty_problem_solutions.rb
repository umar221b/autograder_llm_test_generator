# 868
# solutions with empty results
problem_id = 8
sol_ids = SolutionTestCaseResult.joins(:solution).where("output IS NULL AND runtime_errors = '' AND solutions.problem_id = ?", problem_id).pluck('solutions.id').uniq
sol_ids.size
solutions = Solution.includes(problem: :test_suites).where(id: sol_ids).order(id: :desc).load

results = solutions.map do |solution|
  test_suite_type = TestSuite::GENERATED_BY_LLM
  # test_suite_type = TestSuite::GENERATED_BY_INSTRUCTOR_RUN_BY_US
  # solution_id = 14846
  # solution = Solution.find(solution_id)
  # test_suite = solution.problem.test_suites.find_by(generated_by: test_suite_type)
  test_suite = nil
  solution.problem.test_suites.each do |test_su|
    if test_su.generated_by == test_suite_type
      test_suite = test_su
      break
    end
  end
  service = EvaluationServices::EvaluateOneSolutionService.new(solution, test_suite)
  service.run
  service.data
end

results.each do |individual_result|
  result = individual_result[:solution_test_suite_grades]
  all_test_cases_results = individual_result[:solution_test_case_results]
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
  SolutionTestSuiteGrade.upsert_all(result, unique_by: %i[test_suite_id solution_id])
end
