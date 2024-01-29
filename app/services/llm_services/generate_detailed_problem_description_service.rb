require 'json'

module LlmServices
  class GenerateDetailedProblemDescriptionService < ChatQueryService
    def initialize(problem)
      super
      @problem = problem
      @client = OpenAI::Client.new
    end

    def perform
      new_query_log(LlmChatQuery::QUERY_TYPE_DETAILED_PROBLEM_STATEMENT)

      system_query = get_system_template(LlmChatQuery::QUERY_TYPE_DETAILED_PROBLEM_STATEMENT)
      user_query = get_user_template(LlmChatQuery::QUERY_TYPE_DETAILED_PROBLEM_STATEMENT, @problem.statement, @problem.reference_solution)

      messages = [
        { role: LlmQueryMessage::ROLE_SYSTEM, content: system_query },
        { role: LlmQueryMessage::ROLE_USER, content: user_query }
      ]

      add_messages(messages)

      return unless save_query_log


      response = @client.chat(
        parameters: {
          model: Rails.application.credentials.dig(:openai, :model),
          response_format: { type: "json_object" },
          messages: messages,
          temperature: Rails.application.credentials.dig(:openai, :temperature),
        }
      )

      # response = fake_response_matching_outputs # TODO: Remove

      finish_reason = response.dig("choices", 0, "finish_reason")
      content = response.dig("choices", 0, "message", "content")

      input_token_count = response.dig("usage", "prompt_tokens")
      output_token_count = response.dig("usage", "completion_tokens")

      add_query_response_fields(finish_reason, content, input_token_count, output_token_count)

      save_query_log

      @data = { llm_chat_query: @llm_chat_query }
    end

    private

    def fake_response_matching_outputs
      content = { "scenario": "In Happy Land, the happiness status of citizens is indicated by their car's license plate numbers. A car plate number ending in 9 signifies a happy citizen. The task is to determine whether a given car plate number belongs to a happy or a not-yet-happy citizen.", "inputs": "A single integer 'n', representing the car’s plate number.", "outputs": "A string: 'Happy' if the car belongs to a happy citizen, 'Not yet' if it belongs to a not-yet-happy citizen.", "example": "Input: 502498, Output: Not yet; Input: 123459, Output: Happy", "limits": "The input integer 'n' will be within the range of 0 to 2^31 - 1. Time complexity is O(1), and space complexity is minimal." }
      response = { choices: [{ finish_reason: "stop", message: { content: JSON.dump(content) } }] }
      response.with_indifferent_access
    end

    def fake_response_unit_tests
      content = { "scenario": "The task is to create a function that processes a given string to return a new string constructed from every other character of the original string, starting with the first character.", "inputs": "A string (denoted as 'str' in the solution). This string is the input from which the new string will be created.", "outputs": "A string. This is a new string formed by concatenating every other character from the input string, starting with the first character.", "example": "1. string_bits('Hello') → 'Hlo' 2. string_bits('Hi') → 'H' 3. string_bits('Heeololeo') → 'Hello'", "limits": "Time Complexity: O(n), Space Complexity: O(n), Memory Limits: Not specified, Input Length: Not explicitly limited." }
      response = { choices: [{ finish_reason: "stop", message: { content: JSON.dump(content) } }] }
      response.with_indifferent_access
    end
  end
end