i = -1

problems = Problem.order(:id).all

i = i + 1
while true
  problem = problems[i]
  if [14, 21].include?(problem.id)
    puts "Skipping problem, grading not ready.."
    break
  end
  test_suite = problem.test_suites.find_by(generated_by: TestSuite::GENERATED_BY_LLM)
  service = EvaluationServices::EvaluateProblemService.new(test_suite)
  service.run
  if service.data.blank?
    GC.start
    break
  end
end
