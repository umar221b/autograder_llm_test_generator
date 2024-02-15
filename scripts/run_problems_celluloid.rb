time_start = Time.now
require 'code_execution'
require 'celluloid'
require "celluloid/autostart"
require "celluloid/pool"

class Worker
  include Celluloid
  def process_solution(solution, tests, optimal_test_cases)
    tests_total = tests.size
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
end
problem = Problem.find(9)
test_suite = problem.test_suites.find_by(generated_by: TestSuite::GENERATED_BY_LLM)
tests = test_suite.test_cases.order(:id).map { |test| { 'input' => test.test } }

runner = CodeExecution::StandardCIORunner.new(problem.reference_solution, tests)
optimal_test_cases = runner.generate_test_outputs

solutions = problem.solutions.limit(50)
worker_pool = Worker.pool(size: 15)
# If you need to collect the return values check out 'futures'
results = solutions.map do |solution|
  worker_pool.future.process_solution(solution, tests, optimal_test_cases)
end

final_results = results.map(&:value)
time_end = Time.now
(time_end.to_i - time_start.to_i) / 60.0

