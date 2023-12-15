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

    response = @client.chat(
      parameters: {
        model: Rails.application.credentials.dig(:openai, :model),
        response_format: { type: "json_object" },
        messages: messages,
        temperature: Rails.application.credentials.dig(:openai, :temperature),
      }
    )

    # response = fake_response

    finish_reason = response.dig("choices", 0, "finish_reason")
    content = response.dig("choices", 0, "message", "content")
    output_token_count = content ? OpenAI.rough_token_count(content) : 0

    add_query_response_fields(finish_reason, content, output_token_count)
    save_query_log

    @data = { message: content, llm_query: @llm_query }
  end

  private

  def fake_response
    content = { "scenario": "We need to determine if a given string contains the substring 'xyz' that is not directly preceded by a period (.). The presence of 'xyz' without a leading period should return True, while 'xyz' with a leading period or its absence should return False.", "inputs": "A single string parameter that needs to be checked for the occurrence of 'xyz' without a period directly before it.", "outputs": "A boolean value, True if 'xyz' appears in the string without being directly preceded by a period, otherwise False.", "example": "xyz_there('abcxyz') → True; xyz_there('abc.xyz') → False; xyz_there('xyz.abc') → True", "limits": "The function should perform efficiently on typical string lengths where string operations are considered O(n) time complexity. There are no specific memory or time limits provided, but the solution should avoid unnecessary computation." }
    response = { choices: [{ finish_reason: "stop", message: { content: JSON.dump(content) } }] }
    response.with_indifferent_access
  end
end