Problem.order(:id).each_with_index do |problem, index|
  service = ProblemsServices::GenerateProblemLlmChatQueryService.new(problem)
  if service.run
    puts "Problem #{problem.title} with index #{index} all good."
  else
    puts "Issues creating queries for problem #{problem.title} with index: #{index}"
    puts service.errors.full_messages.join(', and ')
  end
rescue StandardError => e
  puts e, "=============", e.backtrace, "=============", e.message
end