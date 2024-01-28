module TestProblemsServices
  class ImportAllTestProblemsService < ApplicationService
    def perform
      messages = {}
      Dir.each_child('test_problems/problems') do |filename|
        next if filename[0] == '.' # skip hidden files

        problem_name = File.basename(filename, '.xml')
        messages[problem_name] = []
        problem_service = ImportTestProblemService.new(problem_name)

        unless problem_service.run
          messages[problem_name] = problem_service.errors.full_messages
          next
        end

        solutions_service = ImportTestProblemSolutionsService.new(problem_name, problem_service.data[:test_suite])
        unless solutions_service.run
          messages[problem_name] += solutions_service.errors.full_messages
        end
      end
      messages.each do |problem_name, errors|
        next if errors.blank?

        puts "Problem: #{problem_name}"
        puts errors.join(', and ')
      end
      true
    end
  end
end