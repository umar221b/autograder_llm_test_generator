require 'json'

class UnitTestsService < LlmQueryService
  def initialize(detailed_problem_statement, instructor_code)
    super
    @problem_statement = JSON.parse(detailed_problem_statement)
    @instructor_code = instructor_code
    @client = OpenAI::Client.new
  end

  def perform
    new_query_log

    system_query = get_system_template('unit_tests')
    user_query = get_user_template('unit_tests',
                                   @problem_statement["scenario"],
                                   @problem_statement["inputs"],
                                   @problem_statement["outputs"],
                                   @problem_statement["example"],
                                   @problem_statement["limits"],
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

    response = @client.chat(
      parameters: {
        model: Rails.application.credentials.dig(:openai, :model),
        messages: messages,
        temperature: Rails.application.credentials.dig(:openai, :temperature),
      })

    # response = fake_response

    finish_reason = response.dig("choices", 0, "finish_reason")
    content = response.dig("choices", 0, "message", "content")
    output_token_count = content ? OpenAI.rough_token_count(content.to_s) : 0

    add_query_response_fields(finish_reason, content, output_token_count)
    save_query_log

    code = @llm_query&.to_s

    @data = { message: content, code: code, llm_query: @llm_query }
  end

  private

  def fake_response
    content = """
      Based on the problem description and constraints, let's identify the edge cases to test the provided solution:

1. **Empty String**: The string is empty (`""`). The expected output should be `False` as there is no occurrence of \"xyz\".

2. **String Without \"xyz\"**: The string does not contain the substring \"xyz\" at all (e.g., `\"abc\"`). The expected output should be `False`.

3. **String With Only \"xyz\"**: The string consists of only \"xyz\" (e.g., `\"xyz\"`). The expected output should be `True`.

4. **String With \"xyz\" Preceded by a Period**: The string contains \"xyz\" but it is always preceded by a period (e.g., `\".xyz\"` or `\"abc.xyz\"`). The expected output should be `False`.

5. **String With Multiple \"xyz\" Occurrences**: The string contains multiple occurrences of \"xyz\", with some being valid and others preceded by a period (e.g., `\"abc.xyzxyz\"`). The expected output depends on the presence of a valid \"xyz\" substring.

6. **Long String With \"xyz\" at the End**: A long string where \"xyz\" occurs at the very end (e.g., `\"a\" * 10000 + \"xyz\"`). This tests the efficiency of the algorithm.

7. **String with Separated \"xyz\" Characters**: The string contains separated \"xyz\" characters not forming the substring \"xyz\" (e.g., `\"x.y.z\"`). The expected output should be `False`.

8. **\"xyz\" With Additional Characters**: The string contains \"xyz\" with additional characters either at the beginning, in the middle, or at the end (e.g., `\"axyzb\"`, `\"xayz\"`, `\"xyaz\"`). The expected output should be `False` in these cases.

Reflection:
- The edge cases cover different scenarios including the presence and absence of the \"xyz\" substring, its position in the string, and its relationship with the preceding character.
- The optimal solution seems to skip two characters after encountering a period. This approach might miss valid \"xyz\" occurrences if they start within two characters after a period.
- The solution checks for the sequence \"xyz\" character by character, which is efficient, but the skipping logic might lead to incorrect results in some cases.

Adjustments based on Reflection:
- An additional edge case should be included where \"xyz\" occurs within two characters after a period (e.g., `\".axyz\"`). The expected output should be `True` as the \"xyz\" is not directly preceded by a period.

Now, I will proceed to write Python unit tests for these edge cases, including 20 random test cases, and import the solution from a file named \"solution\".

```python
import unittest
import random
import string
from solution import xyz_there

class TestXyzThere(unittest.TestCase):
    def test_empty_string(self):
        self.assertFalse(xyz_there(""))

    def test_string_without_xyz(self):
        self.assertFalse(xyz_there(\"abc\"))

    def test_string_with_only_xyz(self):
        self.assertTrue(xyz_there(\"xyz\"))

    def test_string_with_xyz_preceded_by_period(self):
        self.assertFalse(xyz_there(\".xyz\"))
        self.assertFalse(xyz_there(\"abc.xyz\"))

    def test_string_with_multiple_xyz(self):
        self.assertTrue(xyz_there(\"abc.xyzxyz\"))

    def test_long_string_with_xyz_at_end(self):
        self.assertTrue(xyz_there(\"a\" * 10000 + \"xyz\"))

    def test_string_with_separated_xyz_characters(self):
        self.assertFalse(xyz_there(\"x.y.z\"))

    def test_xyz_with_additional_characters(self):
        self.assertFalse(xyz_there(\"axyzb\"))
        self.assertFalse(xyz_there(\"xayz\"))
        self.assertFalse(xyz_there(\"xyaz\"))

    def test_xyz_within_two_chars_after_period(self):
        self.assertTrue(xyz_there(\".axyz\"))

    def generate_random_string(self, length):
        return ''.join(random.choices(string.ascii_lowercase + '.', k=length))

    def test_random_cases(self):
        for _ in range(20):
            random_str = self.generate_random_string(random.randint(1, 100))
            with self.subTest(random_str=random_str):
                # The test here is less about correctness and more about handling varied inputs
                self.assertIn(xyz_there(random_str), [True, False])

if __name__ == '__main__':
    unittest.main()

```

The Python unit tests for the specified edge cases and additional random test cases have been written successfully. However, I encountered a `ModuleNotFoundError` because the `solution` module, which should contain the `xyz_there` function, is not present in this environment.

In a typical setup, these tests would be executed in an environment where the `solution` module is available. For now, the tests are ready and can be used to verify the correctness and robustness of the provided solution when integrated into an appropriate Python development environment.

If you have any further questions or need assistance with another aspect of this task, feel free to ask!
    """



    response = { "choices": [{ "finish_reason": "stop", "message": { "content": content } }] }
    response.with_indifferent_access
  end
end