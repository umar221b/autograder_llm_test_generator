require 'json'

class DetailedProblemDescriptionService < LlmQueryService
  def initialize(problem_statement, instructor_code)
    super
    @problem_statement = problem_statement
    @instructor_code = instructor_code
    @client = OpenAI::Client.new
  end

  def perform
    new_query_log

    system_query = get_system_template('detailed_problem_statement')
    user_query = get_user_template('detailed_problem_statement', @problem_statement, @instructor_code)

    input_token_count = OpenAI.rough_token_count(system_query)
    input_token_count += OpenAI.rough_token_count(user_query)

    messages = [
      { role: "system", content: system_query },
      { role: "user", content: user_query }
    ]

    add_query_request_fields(input_token_count, messages)
    return unless save_query_log

    # response = @client.chat(
    #   parameters: {
    #     model: Rails.application.credentials.dig(:openai, :model),
    #     response_format: { type: "json_object" },
    #     messages: messages,
    #     temperature: Rails.application.credentials.dig(:openai, :temperature),
    #   }
    # )

    response = fake_response

    finish_reason = response.dig("choices", 0, "finish_reason")
    content = response.dig("choices", 0, "message", "content")
    output_token_count = content ? OpenAI.rough_token_count(content) : 0

    add_query_response_fields(finish_reason, content, output_token_count)
    save_query_log

    @data = { message: content, llm_query: @llm_query }
  end

  private

  def fake_response
    content = { "scenario": "The task is to create a function that processes a given string to return a new string constructed from every other character of the original string, starting with the first character.", "inputs": "A string (denoted as 'str' in the solution). This string is the input from which the new string will be created.", "outputs": "A string. This is a new string formed by concatenating every other character from the input string, starting with the first character.", "example": "1. string_bits('Hello') → 'Hlo' 2. string_bits('Hi') → 'H' 3. string_bits('Heeololeo') → 'Hello'", "limits": "Time Complexity: O(n), Space Complexity: O(n), Memory Limits: Not specified, Input Length: Not explicitly limited." }
    response = { choices: [{ finish_reason: "stop", message: { content: JSON.dump(content) } }] }
    response.with_indifferent_access
  end
end