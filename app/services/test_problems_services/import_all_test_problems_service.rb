module TestProblemsServices
  class ImportAllTestProblemsService < ApplicationService
    def perform
      Dir.each_child('test_problems/problems') do |filename|
        problem_service = ImportTestProblemService.new(filename)

        unless problem_service.run
          puts problem_service.errors.full_messages.join(', and ')
          next
        end

        solutions_service = ImportTestProblemSolutionsService(filename, problem_service.data[:test_problem])
        unless solutions_service.run
          puts solutions_service.errors.full_messages.join(', and ')
        end
      end
      true
    end
  end
end