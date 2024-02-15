time_start = Time.now
require 'code_execution'
problem = Problem.find(9)

test_suite = problem.test_suites.find_by(generated_by: TestSuite::GENERATED_BY_LLM)
tests = test_suite.test_cases.order(:id).map { |test| { 'input' => test.test } }
tests_total = tests.size

runner = CodeExecution::StandardCIORunner.new(problem.reference_solution, tests)
optimal_test_cases = runner.generate_test_outputs

solutions = problem.solutions.all

solution_grades = Parallel.map(solutions) do |solution|
  puts "Working on Solution ##{solution.id}."

  solution_evaluation = { id: solution.id, correct: 0, wrong: [] }

  runner = CodeExecution::StandardCIORunner.new(solution.code, tests)
  test_cases = runner.generate_test_outputs

  test_cases.each_with_index do |test_case, index|
    if test_case.error.present? || test_case.output !=  optimal_test_cases[index].output
      solution_evaluation[:wrong] << index
      next
    end
    solution_evaluation[:correct] += 1
  end
  puts "Solution ##{solution.id}: #{solution_evaluation[:correct]}/#{tests_total}."
  solution_evaluation
end


time_end = Time.now
(time_end.to_i - time_start.to_i) / 60.0

solution_grades.map{ |s| s[:correct] }.select{ |i| i > 0 }.size
solutions.includes(:solution_test_suite_grades).where(solution_test_suite_grades: { test_suite_id: test_suite.id }).pluck('solution_test_suite_grade.grade')