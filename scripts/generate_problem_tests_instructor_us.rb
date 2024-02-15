problems = Problem.order(:id)
issues = []
problems.each_with_index do |problem, index|
  puts "INDEX: #{index}"
  puts "=============="
  puts problem.title
  puts "=============="
  test_suite = problem.test_suites.find_by(generated_by: TestSuite::GENERATED_BY_INSTRUCTOR)
  s = ProblemsServices::GenerateInstructorUsSuiteService.new(test_suite)
  issues << [problem.title, s.errors.full_messages] unless s.run
rescue StandardError => e
  issues << e.message
end