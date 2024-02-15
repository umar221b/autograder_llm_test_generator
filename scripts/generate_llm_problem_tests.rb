problems = Problem.order(:id)
issues = []
problems.each_with_index do |problem, index|
  puts "INDEX: #{index}"
  puts "=============="
  puts problem.title
  puts "=============="
  llm_chat_query = problem.llm_chat_queries.last
  s = ProblemsServices::GenerateLlmTestSuiteService.new(llm_chat_query)
  issues << [problem.title, s.errors.full_messages] unless s.run
rescue StandardError => e
  issues << e.message
end