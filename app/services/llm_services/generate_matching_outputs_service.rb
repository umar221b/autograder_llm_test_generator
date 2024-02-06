require 'json'

module LlmServices
  class GenerateMatchingOutputsService < ChatQueryService
    def initialize(problem, detailed_problem_statement)
      super
      @problem = problem
      @detailed_problem_statement = detailed_problem_statement
      @client = OpenAI::Client.new
    end

    def perform
      new_query_log(LlmChatQuery::QUERY_TYPE_MATCHING_OUTPUTS)

      system_query = get_system_template(LlmChatQuery::QUERY_TYPE_MATCHING_OUTPUTS)
      user_query = get_user_template(
        LlmChatQuery::QUERY_TYPE_MATCHING_OUTPUTS,
        @detailed_problem_statement["scenario"], @detailed_problem_statement["inputs"],
        @detailed_problem_statement["outputs"], @detailed_problem_statement["example"],
        @detailed_problem_statement["limits"], @problem.reference_solution
      )

      messages = [
        { role: LlmQueryMessage::ROLE_SYSTEM, content: system_query },
        { role: LlmQueryMessage::ROLE_USER, content: user_query }
      ]

      add_messages(messages)

      return unless save_query_log

      response = @client.chat(
        parameters: {
          model: Rails.application.credentials.dig(:openai, :model),
          messages: messages,
          temperature: Rails.application.credentials.dig(:openai, :temperature),
        })

      puts "==============="
      puts response
      puts "==============="
      puts response.dig("choices", 0, "message", "content")
      puts "==============="

      # response = fake_response # TODO: Remove

      finish_reason = response.dig("choices", 0, "finish_reason")
      content = response.dig("choices", 0, "message", "content")

      input_token_count = response.dig("usage", "prompt_tokens")
      output_token_count = response.dig("usage", "completion_tokens")

      add_query_response_fields(finish_reason, content, input_token_count, output_token_count)

      save_query_log

      @data = { llm_chat_query: @llm_chat_query }
    end

    private

    def fake_response
      content = "### Edge Case Descriptions and Examples\n\n1. **Minimum Positive Radii**: This edge case tests the scenario where both radii are at their minimum positive values that can be represented in double precision floating-point format. This tests the program's ability to handle very small numbers.\n\n    **Example**: `input: \"0.0000000000000001 0.00000000000000001\"`\n\n2. **Maximum Radii**: This edge case tests the scenario where both radii are at their maximum values that can be represented in double precision floating-point format without causing overflow in the calculation. This tests the program's ability to handle very large numbers.\n\n    **Example**: `input: \"1.7976931348623157e+308 1.7976931348623157e+307\"`\n\n3. **Equal Radii**: This edge case tests the scenario where both radii are equal. The expected output should be zero since there would be no cross-sectional area in a pipe with no thickness.\n\n    **Example**: `input: \"5.0 5.0\"`\n\n4. **Larger Radius is Much Larger than Smaller Radius**: This edge case tests the scenario where the larger radius is significantly larger than the smaller radius, testing the program's ability to handle a wide range of radius differences.\n\n    **Example**: `input: \"100.0 1.0\"`\n\n5. **Very Close Radii**: This edge case tests the scenario where the radii are very close to each other, but not equal. This tests the program's precision in calculating areas with very thin cross-sections.\n\n    **Example**: `input: \"5.0001 5.0\"`\n\n### Reflection\n\nUpon reflection, the edge cases cover scenarios of minimum and maximum values, equal radii, significantly different radii, and very close radii. These cases should adequately test the program's ability to handle a wide range of inputs and calculate the cross-sectional area accurately.\n\nHowever, there was an oversight in the description of the maximum radii edge case. The provided values might cause an overflow in the calculation due to the squaring of very large numbers. To correct this, the maximum radii example should be adjusted to ensure the calculation does not exceed the limits of double precision floating-point format.\n\n### Corrected Edge Case Example for Maximum Radii\n\n2. **Maximum Radii (Corrected)**: This edge case tests the scenario with large, but not maximum, radii to avoid overflow in the calculation.\n\n    **Example**: `input: \"1e+154 1e+153\"`\n\n### Python3 Code for Generating Test Cases\n\n```python\nimport json\nimport random\n\ndef generate_random_cases(n):\n    cases = []\n    for _ in range(n):\n        r1 = random.uniform(0.0000000000000001, 1e+154)\n        r2 = random.uniform(0.0000000000000001, r1)  # Ensure r2 is always smaller than or equal to r1\n        case = {\"input\": f\"{r1} {r2}\"}\n        cases.append(case)\n    return cases\n\ndef main():\n    edge_cases = [\n        {\"input\": \"0.0000000000000001 0.00000000000000001\"},\n        {\"input\": \"1e+154 1e+153\"},\n        {\"input\": \"5.0 5.0\"},\n        {\"input\": \"100.0 1.0\"},\n        {\"input\": \"5.0001 5.0\"}\n    ]\n    \n    random_cases = generate_random_cases(100)\n    all_cases = edge_cases + random_cases\n    \n    with open('test_cases.json', 'w') as f:\n        json.dump(all_cases, f, indent=4)\n\nif __name__ == \"__main__\":\n    main()\n```\n\nThis Python script generates a JSON file containing the improved edge cases and an additional 100 random test cases within the specified limits."
      response = { "choices": [{ "finish_reason": "stop", "message": { "content": content } }], usage: { prompt_tokens: 875, completion_tokens: 817, total_tokens: 1692 } }
      response.with_indifferent_access
    end
  end
end