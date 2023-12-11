class DetailedProblemDescriptionService < ApplicationService
  def initialize(problem_statement, instructor_code)
    @problem_statement = problem_statement
    @instructor_code = instructor_code
    @client = OpenAI::Client.new
  end

  def perform

    user_query =
"""
Problem Statement:
#{@problem_statement}

Optimal Solution:
```
#{@instructor_code}
```
"""
    input_token_count = OpenAI.rough_token_count(PromptTemplates::DETAILED_PROBLEM_STATEMENT)
    input_token_count += OpenAI.rough_token_count(user_query)

    response = @client.chat(
      parameters: {
        model: Rails.application.credentials.dig(:openai, :model),
        response_format: { type: "json_object" },
        messages: [
          { role: "system", content: PromptTemplates::DETAILED_PROBLEM_STATEMENT },
          { role: "user", content: user_query }
        ],
        temperature: 0.2,
      })
    puts "DETAILED PROBLEM STATEMENT SERVICE RESPONSE"
    puts "========================"
    puts response

    finish_reason = response.dig("choices", 0, "finish_reason")
    if finish_reason == 'length'
      errors.add(:base, 'Response was too long')
    else
      content = response.dig("choices", 0, "message", "content")
      output_token_count = OpenAI.rough_token_count(content)
      puts "DETAILED PROBLEM STATEMENT SERVICE CONTENT"
      puts "========================"
      puts content
      @data = { tokens: [input_token_count, output_token_count], message: content }
    end
  end
end