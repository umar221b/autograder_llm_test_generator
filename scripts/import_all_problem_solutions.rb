# Reimport all problem solutions
problem_name_problem_mapping = {
  'around_the_letters' => 9, 'cross_section' => 12,
  'escape_border' => 4, 'shipping_containers' => 24,
  'a_function_that_prints!' => 13, 'a_function_that_returns!' => 3,
  'count_zeroes' => 15, 'print_array_values' => 8,
  'wall_street_bet' => 22, 'box_moving_straight_lines' => 2,
  'find_tile' => 19, 'make_move' => 28,
  'look_in_the_mirror' => 25, 'where_is_the_last_one' => 20,
  'capital_importance' => 17, 'censor' => 16,
  'palindromes' => 10, 'text_histogram' => 26,
  'digital_vines' => 21, 'histogram' => 14,
  'word_chain' => 7, 'recursive_combinations' => 1,
  'recursive_conversion' => 23, 'recursive_reverse' => 6,
  'midpoint' => 27, 'next_letter' => 5,
  'our_own_hello_world' => 18, 'twice_as_nice' => 11,
}


messages = {}
Dir.each_child('test_problems/solutions') do |filename|
  next if filename[0] == '.' # skip hidden files

  problem_name = File.basename(filename, '.csv')
  messages[problem_name] = []

  problem = Problem.find(problem_name_problem_mapping[problem_name])
  test_suite = problem.test_suites.find_by(generated_by: TestSuite::GENERATED_BY_INSTRUCTOR)
  solutions_service = ProblemsServices::ImportTestProblemSolutionsService.new(problem_name, test_suite)
  unless solutions_service.run
    messages[problem_name] << solutions_service.errors.full_messages
  end
end