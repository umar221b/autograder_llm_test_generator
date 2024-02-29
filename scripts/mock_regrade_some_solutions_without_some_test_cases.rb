require 'differ'

def c(wrong, i)
  diff = diff_outputs(wrong[i])
  puts diff.join("\n'=================\n")
  puts wrong[i][:solution_test_suite_grades][:solution_id]
end

def p_c(wrong, i, c)
  puts wrong[i][:solution_test_case_results][c][:output]
end

def diff_outputs(result, special = true)
  test_case_ids = result[:solution_test_case_results].map { |r| r[:test_case_id] }
  accepted_cases = TestCase.where(id: test_case_ids)
  if special
    accepted_cases.each do |accepted_case|
      next if accepted_case.expected_output.blank?

      accepted_case.expected_output = accepted_case.expected_output.squeeze("\n")
    end
  end
  accepted_cases = accepted_cases.index_by(&:id)
  diffs = []
  result[:solution_test_case_results].each do |test_case_result|
    if test_case_result[:runtime_errors].blank?
      diffs << Differ.diff(accepted_cases[test_case_result[:test_case_id]].expected_output, test_case_result[:output])
    else
      diffs << "Runtime Error: #{test_case_result[:runtime_errors]}"
    end
  end
  diffs
end

def compare_outputs(solution, test_suite, excluded_test_case_ids, only_valid, special = false)
  accepted_cases = test_suite.test_cases.accepted.where.not(id: excluded_test_case_ids)
  accepted_cases = accepted_cases.valid if only_valid
  if special
    accepted_cases.each do |accepted_case|
      next if accepted_case.expected_output.blank?

      accepted_case.expected_output = accepted_case.expected_output.squeeze("\n")
    end
  end
  solution_test_case_results = SolutionTestCaseResult.where(test_case_id: accepted_cases.ids, solution_id: solution.id)
  if special
    solution_test_case_results.each do |solution_test_case_result|
      next if solution_test_case_result.output.blank?

      solution_test_case_result.output = solution_test_case_result.output.squeeze("\n")
    end
  end
  accepted_cases = accepted_cases.index_by(&:id)
  all_test_case_results = []
  grade = 0

  solution_test_case_results.each do |test_case_result|
    test_case_results = {
      solution_id: solution.id, test_case_id: test_case_result.test_case_id,
      output: test_case_result.output, runtime_errors: test_case_result.runtime_errors
    }

    if test_case_result.runtime_errors.blank?
      grade += 1 if Differ.no_diff?(accepted_cases[test_case_result.test_case_id].expected_output, test_case_result.output)
    end

    all_test_case_results << test_case_results
  end
  grade /= solution_test_case_results.size.to_f

  [grade, all_test_case_results]
end


problem_id = 27
problem = Problem.includes(:test_suites).find(problem_id)
test_suite_type = TestSuite::GENERATED_BY_LLM
test_suite = problem.test_suites.find_by(generated_by: test_suite_type)
solution_ids = [34786, 34789, 34811, 34814, 34817, 34820, 34830, 34832, 34844, 34859, 34869, 34871, 34874, 34901, 34902, 34909, 34918, 34924, 34926, 34927, 34928, 34947, 34949, 34954, 34960, 34962, 34964, 34972, 34985, 34988, 35013, 35014, 35020, 35022, 35023, 35025, 35026, 35030, 35031, 35034, 35036, 35039, 35041, 35075, 35085, 35126, 35130, 35132, 35135, 35136, 35158, 35172, 35179, 35183, 35187, 35189, 35197, 35205, 35207, 35211, 35217, 35221, 35224, 35235, 35241, 35282, 35284, 35287, 35301, 35304, 35305, 35321, 35327, 35328, 35330, 35334, 35337, 35339, 35340, 35343, 35344, 35349, 35352, 35360, 35362, 35368, 35385, 35388, 35390, 35391, 35403, 35411, 35416, 35420, 35444, 35464, 35465, 35475, 35478, 35479, 35484, 35486, 35498, 35503, 35507, 35521, 35524, 35528, 35531, 35539, 35541, 35542, 35559, 35560, 35563, 35565, 35566, 35571, 35573, 35609, 35620, 35623, 35633, 35635, 35638, 35644, 35660, 35667, 35670, 35697, 35699, 35702, 35723, 35728, 35729, 35731, 35734, 35736, 35741, 35743, 35744, 35764, 35767, 35768]
excluded_test_case_ids = []
results = []
only_valid = true
special = true
Solution.where(id: solution_ids).find_each do |solution|
  solution_evaluation = {
    solution_id: solution.id, test_suite_id: test_suite.id,
    grade: 0
  }
  grade, solution_test_case_results = compare_outputs(solution, test_suite, excluded_test_case_ids, only_valid, special)
  solution_evaluation[:grade] = grade

  results << {
    solution_test_suite_grades: solution_evaluation,
    solution_test_case_results: solution_test_case_results
  }
end


final = results.map { |r| [r[:solution_test_suite_grades][:solution_id], r[:solution_test_suite_grades][:grade]] }.select { |r| r[1] == 1.0 }
wrong = results.select { |r| r[:solution_test_suite_grades][:grade] != 1 }.sort { |r, o| r[:solution_test_suite_grades][:solution_id] <=> o[:solution_test_suite_grades][:solution_id] }

i = -1
i = i + 1
c(wrong, i)

