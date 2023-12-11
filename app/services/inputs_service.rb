require 'json'

class InputsService < ApplicationService
  def initialize(detailed_problem_statement, instructor_code)
    @detailed_problem_statement = JSON.parse(detailed_problem_statement)
    @instructor_code = instructor_code
    @client = OpenAI::Client.new
  end

  def perform

    user_query =
"""
Scenario Section:

#{@detailed_problem_statement[:scenario]}

Input Format Section:

#{@detailed_problem_statement[:inputs]}

Output Format Section:

#{@detailed_problem_statement[:outputs]}

Example Section:

#{@detailed_problem_statement[:example]}

Limits Section:

#{@detailed_problem_statement[:limits]}

Optimal Solution Section:

```
#{@instructor_code}
```
"""

    input_token_count = OpenAI.rough_token_count(PromptTemplates::INPUTS)
    input_token_count += OpenAI.rough_token_count(user_query)

    response = @client.chat(
      parameters: {
        model: Rails.application.credentials.dig(:openai, :model),
        response_format: { type: "json_object" },
        messages: [
          { role: "system", content: PromptTemplates::INPUTS },
          { role: "user", content: user_query }
        ],
        temperature: 0.2,
      })

    puts "INPUTS SERVICE RESPONSE"
    puts "========================"
    puts response

    finish_reason = response.dig("choices", 0, "finish_reason")
    if finish_reason == 'length'
      errors.add(:base, 'Response was too long')
    else
      content = response.dig("choices", 0, "message", "content")
      output_token_count = OpenAI.rough_token_count(content)
      puts "INPUTS SERVICE CONTENT"
      puts "========================"
      puts content
      @data = { tokens: [input_token_count, output_token_count], message: content }
    end
  end
end