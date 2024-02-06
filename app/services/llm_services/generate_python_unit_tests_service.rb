require 'json'

module LlmServices
  class GeneratePythonUnitTestsService < ChatQueryService
    def initialize(problem, detailed_problem_statement)
      super
      @problem = problem
      @detailed_problem_statement = detailed_problem_statement
      @client = OpenAI::Client.new
    end

    def perform
      new_query_log(LlmChatQuery::QUERY_TYPE_UNIT_TESTS)

      system_query = get_system_template(LlmChatQuery::QUERY_TYPE_UNIT_TESTS)
      user_query = get_user_template(
        LlmChatQuery::QUERY_TYPE_UNIT_TESTS,
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
      content = "Based on the problem description and the provided solution, we need to identify and create test cases that cover various edge scenarios. Let's consider the edge cases based on the input limits and constraints.\n\n### Edge Cases\n\n1. **Empty String**: The input string is empty (`\"\"`). The expected output should also be an empty string.\n2. **Single Character String**: The input string contains only one character (e.g., `\"a\"`). The output should be the same as the input.\n3. **String with All Identical Characters**: The input string contains all identical characters (e.g., `\"aaaaaa\"`). The output should be every other character starting from the first, which would be a string with half the length of the input if the input length is even, or half plus one if the input length is odd.\n4. **String with Alternate Characters**: The input string has a pattern where every alternate character is different (e.g., `\"ababab\"`). The output should be the first of each pair of characters.\n5. **String with Spaces or Special Characters**: The input string includes spaces or special characters (e.g., `\"h e l l o\"`). Spaces and special characters should be treated as normal characters.\n6. **Very Long String**: The input string is very long (but within memory limits). This tests the function's ability to handle large inputs efficiently.\n7. **String with Unicode Characters**: The input string includes Unicode characters (e.g., emojis, characters in different languages).\n8. **String with Numbers and Letters**: The input string includes a mix of numbers and letters (e.g., `\"a1b2c3\"`).\n\n### Reflection\n\nUpon reflection, these edge cases seem to cover a wide range of possibilities for the input string, including various lengths, characters, and types. The cases account for typical scenarios as well as some less common but possible situations, such as strings with special characters or very long strings.\n\n### Revised Edge Cases\n\nAfter reflection, the edge cases appear comprehensive and well-considered. They should sufficiently test the robustness of the function across various input scenarios. \n\n### Unit Test Code\n\nNow, let's create the unit test code in Python. This code will use the `unittest` library and will include tests for the edge cases described above. Additionally, it will include 100 random test cases.\n\n```python\nimport unittest\nimport string\nimport random\nfrom solution import string_bits as tested_solution\n\ndef instructor_solution(str):\n    new_str = \"\"\n    for i in range(0, len(str)):\n        if i % 2 == 0:\n            new_str += str[i]\n    return new_str\n\nclass TestStringBitsFunction(unittest.TestCase):\n\n    def test_empty_string(self):\n        self.assertEqual(tested_solution(\"\"), instructor_solution(\"\"))\n\n    def test_single_character(self):\n        self.assertEqual(tested_solution(\"a\"), instructor_solution(\"a\"))\n\n    def test_identical_characters(self):\n        self.assertEqual(tested_solution(\"aaaaaa\"), instructor_solution(\"aaaaaa\"))\n\n    def test_alternate_characters(self):\n        self.assertEqual(tested_solution(\"ababab\"), instructor_solution(\"ababab\"))\n\n    def test_string_with_spaces(self):\n        self.assertEqual(tested_solution(\"h e l l o\"), instructor_solution(\"h e l l o\"))\n\n    def test_very_long_string(self):\n        long_str = \"a\" * 10000\n        self.assertEqual(tested_solution(long_str), instructor_solution(long_str))\n\n    def test_unicode_characters(self):\n        self.assertEqual(tested_solution(\"🙂🙃🙂🙃🙂\"), instructor_solution(\"🙂🙃🙂🙃🙂\"))\n\n    def test_numbers_letters_mix(self):\n        self.assertEqual(tested_solution(\"a1b2c3\"), instructor_solution(\"a1b2c3\"))\n\n    def test_random_cases(self):\n        for _ in range(100):\n            random_str = ''.join(random.choices(string.ascii_letters + string.digits, k=random.randint(1, 100)))\n            self.assertEqual(tested_solution(random_str), instructor_solution(random_str))\n\nif __name__ == \"__main__\":\n    unittest.main()\n```\n\nNote: The `solution` module should contain the `string_bits` function that we are testing. The `instructor_solution` function is included as a reference to compare against the tested solution.\n"

      response = { "choices": [{ "finish_reason": "stop", "message": { "content": content } }], usage: { prompt_tokens: 724, completion_tokens: 886, total_tokens: 1610 } }
      response.with_indifferent_access
    end
  end
end