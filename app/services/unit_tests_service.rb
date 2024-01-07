require 'json'

class UnitTestsService < LlmQueryService
  def initialize(problem_statement, detailed_problem_statement, instructor_code)
    super
    @problem_statement = problem_statement
    @detailed_problem_statement = detailed_problem_statement
    @instructor_code = instructor_code
    @client = OpenAI::Client.new
  end

  def perform
    new_query_log(LlmQuery::QUERY_TYPE_UNIT_TESTS)

    system_query = get_system_template(LlmQuery::QUERY_TYPE_UNIT_TESTS)
    user_query = get_user_template(LlmQuery::QUERY_TYPE_UNIT_TESTS,
                                   @detailed_problem_statement["scenario"],
                                   @detailed_problem_statement["inputs"],
                                   @detailed_problem_statement["outputs"],
                                   @detailed_problem_statement["example"],
                                   @detailed_problem_statement["limits"],
                                   @instructor_code
    )

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
    #     messages: messages,
    #     temperature: Rails.application.credentials.dig(:openai, :temperature),
    #   })

    response = fake_response

    finish_reason = response.dig("choices", 0, "finish_reason")
    content = response.dig("choices", 0, "message", "content")
    output_token_count = content ? OpenAI.rough_token_count(content.to_s) : 0

    add_query_response_fields(finish_reason, content, output_token_count)
    return unless save_query_log

    code = @llm_query.code&.to_s

    @data = { message: content, code: code, llm_query: @llm_query }
  end

  private

  def fake_response
    content = <<-TEXT
Based on the problem description and the provided solution, we need to identify and create test cases that cover various edge scenarios. Let's consider the edge cases based on the input limits and constraints.

### Edge Cases

1. **Empty String**: The input string is empty (`""`). The expected output should also be an empty string.
2. **Single Character String**: The input string contains only one character (e.g., `"a"`). The output should be the same as the input.
3. **String with All Identical Characters**: The input string contains all identical characters (e.g., `"aaaaaa"`). The output should be every other character starting from the first, which would be a string with half the length of the input if the input length is even, or half plus one if the input length is odd.
4. **String with Alternate Characters**: The input string has a pattern where every alternate character is different (e.g., `"ababab"`). The output should be the first of each pair of characters.
5. **String with Spaces or Special Characters**: The input string includes spaces or special characters (e.g., `"h e l l o"`). Spaces and special characters should be treated as normal characters.
6. **Very Long String**: The input string is very long (but within memory limits). This tests the function's ability to handle large inputs efficiently.
7. **String with Unicode Characters**: The input string includes Unicode characters (e.g., emojis, characters in different languages).
8. **String with Numbers and Letters**: The input string includes a mix of numbers and letters (e.g., `"a1b2c3"`).

### Reflection

Upon reflection, these edge cases seem to cover a wide range of possibilities for the input string, including various lengths, characters, and types. The cases account for typical scenarios as well as some less common but possible situations, such as strings with special characters or very long strings.

### Revised Edge Cases

After reflection, the edge cases appear comprehensive and well-considered. They should sufficiently test the robustness of the function across various input scenarios.

### Unit Test Code

Now, let's create the unit test code in Python. This code will use the `unittest` library and will include tests for the edge cases described above. Additionally, it will include 100 random test cases.

```python
import unittest
import string
import random
from solution import string_bits as tested_solution

def instructor_solution(str):
    new_str = ""
    for i in range(0, len(str)):
        if i % 2 == 0:
            new_str += str[i]
    return new_str

class TestStringBitsFunction(unittest.TestCase):

    def test_empty_string(self):
        self.assertEqual(tested_solution(""), instructor_solution(""))

    def test_single_character(self):
        self.assertEqual(tested_solution("a"), instructor_solution("a"))

    def test_identical_characters(self):
        self.assertEqual(tested_solution("aaaaaa"), instructor_solution("aaaaaa"))

    def test_alternate_characters(self):
        self.assertEqual(tested_solution("ababab"), instructor_solution("ababab"))

    def test_string_with_spaces(self):
        self.assertEqual(tested_solution("h e l l o"), instructor_solution("h e l l o"))

    def test_very_long_string(self):
        long_str = "a" * 10000
        self.assertEqual(tested_solution(long_str), instructor_solution(long_str))

    def test_unicode_characters(self):
        self.assertEqual(tested_solution("🙂🙃🙂🙃🙂"), instructor_solution("🙂🙃🙂🙃🙂"))

    def test_numbers_letters_mix(self):
        self.assertEqual(tested_solution("a1b2c3"), instructor_solution("a1b2c3"))

    def test_random_cases(self):
        for _ in range(100):
            random_str = ''.join(random.choices(string.ascii_letters + string.digits, k=random.randint(1, 100)))
            self.assertEqual(tested_solution(random_str), instructor_solution(random_str))

if __name__ == "__main__":
    unittest.main()
```

Note: The `solution` module should contain the `string_bits` function that we are testing. The `instructor_solution` function is included as a reference to compare against the tested solution.
TEXT



    response = { "choices": [{ "finish_reason": "stop", "message": { "content": content } }] }
    response.with_indifferent_access
  end
end