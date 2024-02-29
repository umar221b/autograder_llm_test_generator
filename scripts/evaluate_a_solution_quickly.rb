def diff_outputs(result)
  test_case_ids = result[:solution_test_case_results].map { |r| r[:test_case_id] }
  accepted_cases = TestCase.where(id: test_case_ids)
  accepted_cases = accepted_cases.index_by(&:id)
  diffs = []
  result[:solution_test_case_results].each do |test_case_result|
    if test_case_result[:runtime_errors].blank?
      diffs << Differ.diff(test_case_result[:output], accepted_cases[test_case_result[:test_case_id]].expected_output)
    else
      diffs << "Runtime Error: #{test_case_result[:runtime_errors]}"
    end
  end
  diffs
end


solution_ids = [10773, 10859, 10860, 11060, 11608, 11618, 11630, 11710, 11918, 11919, 11953, 11969, 12012, 12039, 12071, 12139, 12309]
solutions = Solution.includes(problem: :test_suites).where(id: solution_ids).order(id: :desc).load
results = []
only_valid = true
solutions.each do |solution|
  # test_suite_type = TestSuite::GENERATED_BY_INSTRUCTOR_RUN_BY_US
  test_suite_type = TestSuite::GENERATED_BY_LLM
  solution_id = 34101
  solution = Solution.find(solution_id)
  test_suite = nil
  solution.problem.test_suites.each do |test_su|
    if test_su.generated_by == test_suite_type
      test_suite = test_su
      break
    end
  end
  service = EvaluationServices::EvaluateOneSolutionService.new(solution, test_suite, only_valid)
  service.run
  results << service.data
  sleep 0.5
end

correct = results.map { |r| [r[:solution_test_suite_grades][0][:solution_id], r[:solution_test_suite_grades][0][:grade]] }.select { |r| r[1] == 1.0 }
wrong = results.select { |r| r[:solution_test_suite_grades][0][:grade] != 1 }.sort { |r, o| r[:solution_test_suite_grades][0][:solution_id] <=> o[:solution_test_suite_grades][0][:solution_id] }

def c(wrong, i)
  diff = diff_outputs(wrong[i])
  puts diff.join("\n'=================\n")
  puts wrong[i][:solution_test_suite_grades][0][:solution_id]
end

def p_c(wrong, i, c)
  puts wrong[i][:solution_test_case_results][c][:output]
end


# results.each do |individual_result|
#   result = individual_result[:solution_test_suite_grades]
#   all_test_cases_results = individual_result[:solution_test_case_results]
#   begin
#     SolutionTestCaseResult.upsert_all(all_test_cases_results, unique_by: %i[solution_id test_case_id])
#   rescue PG::Error, PG::CharacterNotInRepertoire, ArgumentError, ActiveRecord::StatementInvalid => e
#     puts "Before", all_test_cases_results
#     puts e.message
#     all_test_cases_results.each do |test_case_result|
#       # some strings have invalid bytes that break in the db
#       # we replace them with a message if their insertion fails
#       begin
#         SolutionTestCaseResult.upsert(test_case_result, unique_by: %i[solution_id test_case_id])
#       rescue PG::Error, PG::CharacterNotInRepertoire, ArgumentError, ActiveRecord::StatementInvalid => e
#         test_case_result[:output] = test_case_result[:output].encode('UTF-8', :invalid => :replace, :undef => :replace)
#         test_case_result[:output] = test_case_result[:output].gsub("\u0000", '')
#         test_case_result[:output] += "\nOriginal output had invalid bytes that cannot be represented"
#         SolutionTestCaseResult.upsert(test_case_result, unique_by: %i[solution_id test_case_id])
#       end
#     end
#   end
#   SolutionTestSuiteGrade.upsert_all(result, unique_by: %i[test_suite_id solution_id])
# end