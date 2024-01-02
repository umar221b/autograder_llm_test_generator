require_relative 'utils'

categories = get_categories
categories.each do |category|
  problems = get_category_problems(category)
  problems.each do |problem_info|
    tests = get_problem_tests(category, problem_info)
    write_tests_to_file(category, problem_info, tests)
  end
end