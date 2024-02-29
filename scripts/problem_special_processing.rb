def accepted_processing_8(special, accepted_cases)
  if special
    accepted_cases.each do |accepted_case|
      next if accepted_case.expected_output.blank?

      accepted_case.expected_output = accepted_case.expected_output.gsub(/\nRandom/, ' Random')
    end
  end
end

def user_processing_8(special, solution_test_case_results)
  if special
    solution_test_case_results.each do |solution_test_case_result|
      next if solution_test_case_result.output.blank?

      solution_test_case_result.output = solution_test_case_result.output.gsub('Random', ' Random')
      solution_test_case_result.output = solution_test_case_result.output.gsub(/^ Random/, 'Random')
      solution_test_case_result.output = solution_test_case_result.output.gsub(/\nRandom/, ' Random')
    end
  end
end


def accepted_processing_13(special, accepted_cases)
  if special
    accepted_cases.each do |accepted_case|
      next if accepted_case.expected_output.blank?

      accepted_case.expected_output = accepted_case.expected_output.squeeze("\n")
    end
  end
end

def user_processing_13(special, solution_test_case_results)
  if special
    solution_test_case_results.each do |solution_test_case_result|
      next if solution_test_case_result.output.blank?

      solution_test_case_result.output = solution_test_case_result.output.squeeze("\n")
    end
  end
end

def accepted_processing_22(special, accepted_cases)
  if special
    accepted_cases.each do |accepted_case|
      next if accepted_case.expected_output.blank?

      accepted_case.expected_output = accepted_case.expected_output.squeeze("\n")
    end
  end
end

def user_processing_22(special, solution_test_case_results)
  if special
    solution_test_case_results.each do |solution_test_case_result|
      next if solution_test_case_result.output.blank?

      solution_test_case_result.output = solution_test_case_result.output.gsub('Test ending', "\nTest ending")
      solution_test_case_result.output = solution_test_case_result.output.squeeze("\n")
    end
  end
end

