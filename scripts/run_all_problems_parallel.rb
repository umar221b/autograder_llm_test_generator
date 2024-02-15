time_start = Time.now

problems = Problem.all


problems.each do |problem|
  test_suite = problem.test_suites.find_by(generated_by: TestSuite::GENERATED_BY_LLM)
  service = EvaluationServices::EvaluateProblemService.new(test_suite)
  service.run
end

time_end = Time.now
(time_end.to_i - time_start.to_i) / 60.0


problems = Problem.order(:id).all
i = 27
problem = problems[i]
test_suite = problem.test_suites.find_by(generated_by: TestSuite::GENERATED_BY_LLM)
service = EvaluationServices::EvaluateProblemService.new(test_suite)
service.run


