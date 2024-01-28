require 'csv'

module TestProblemsServices
  class ImportTestProblemSolutionsService < ApplicationService
    def initialize(problem_file, test_suite)
      @problem_file = problem_file
      @test_suite = test_suite
      @test_problem = test_suite.test_problem
    end

    def perform
      full_file_path = "test_problems/solutions/#{@problem_file}.csv"
      unless File.file?(full_file_path)
        errors.add(:base, "File #{full_file_path} does not exist.")
        return false
      end

      CSV.foreach(full_file_path, headers: true) do |row|
        solution = Solution.new(
          test_problem_id: @test_problem.id, student_unique_reference: row['upi'],
          try: row['try'], code: row['answer'], submission_time: Time.at(row['time'].to_i)
        )

        solution_test_suite_grade = solution.solution_test_suite_grades.build(test_suite_id: @test_suite.id, grade: row['rawfraction'].to_f)

        unless solution.save
          errors.add(:base, "Could not add solution: (#{solution.student_unique_reference}, #{solution.try}) from file #{@problem_file}")
          errors.merge!(solution.errors)
          errors.merge!(solution_test_suite_grade.errors)
          next
        end
      end

      true
    end
  end
end
