module LlmServices
  class GenerateTestsService < ChatQueryService
    def initialize(problem, detailed_problem_statement)
      super
      @problem = problem
      @detailed_problem_statement = detailed_problem_statement
      @client = OpenAI::Client.new
    end

    def perform
      new_query_log(query_template)

      system_query = get_system_template(query_template)
      user_query = get_user_template(
        query_template,
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

      # response = c_unit_tests_matching_fake_response # TODO: Remove
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

      finish_reason = response.dig("choices", 0, "finish_reason")
      content = response.dig("choices", 0, "message", "content")

      input_token_count = response.dig("usage", "prompt_tokens")
      output_token_count = response.dig("usage", "completion_tokens")

      add_query_response_fields(finish_reason, content, input_token_count, output_token_count)

      save_query_log

      @data = { llm_chat_query: @llm_chat_query }
    end

    private

    def query_template
      @query_template ||= if @problem.test_type == Problem::TEST_TYPE_MATCHING_OUTPUTS
        LlmChatQuery::QUERY_TEMPLATE_MATCHING_OUTPUTS
      elsif @problem.test_type == Problem::TEST_TYPE_PYTHON3_UNIT_TESTS
        LlmChatQuery::QUERY_TEMPLATE_PYTHON3_UNIT_TESTS
      elsif @problem.test_type == Problem::TEST_TYPE_C_UNIT_TESTS
        LlmChatQuery::QUERY_TEMPLATE_C_UNIT_TESTS
      elsif @problem.test_type == Problem::TEST_TYPE_C_UNIT_TESTS_MATCHING
        LlmChatQuery::QUERY_TEMPLATE_C_UNIT_TESTS_MATCHING
      end
    end

    def matching_outputs_fake_response
      content = "### Edge Case Descriptions and Examples\n\n1. **Minimum Positive Radii**: This edge case tests the scenario where both radii are at their minimum positive values that can be represented in double precision floating-point format. This tests the program's ability to handle very small numbers.\n\n    **Example**: `input: \"0.0000000000000001 0.00000000000000001\"`\n\n2. **Maximum Radii**: This edge case tests the scenario where both radii are at their maximum values that can be represented in double precision floating-point format without causing overflow in the calculation. This tests the program's ability to handle very large numbers.\n\n    **Example**: `input: \"1.7976931348623157e+308 1.7976931348623157e+307\"`\n\n3. **Equal Radii**: This edge case tests the scenario where both radii are equal. The expected output should be zero since there would be no cross-sectional area in a pipe with no thickness.\n\n    **Example**: `input: \"5.0 5.0\"`\n\n4. **Larger Radius is Much Larger than Smaller Radius**: This edge case tests the scenario where the larger radius is significantly larger than the smaller radius, testing the program's ability to handle a wide range of radius differences.\n\n    **Example**: `input: \"100.0 1.0\"`\n\n5. **Very Close Radii**: This edge case tests the scenario where the radii are very close to each other, but not equal. This tests the program's precision in calculating areas with very thin cross-sections.\n\n    **Example**: `input: \"5.0001 5.0\"`\n\n### Reflection\n\nUpon reflection, the edge cases cover scenarios of minimum and maximum values, equal radii, significantly different radii, and very close radii. These cases should adequately test the program's ability to handle a wide range of inputs and calculate the cross-sectional area accurately.\n\nHowever, there was an oversight in the description of the maximum radii edge case. The provided values might cause an overflow in the calculation due to the squaring of very large numbers. To correct this, the maximum radii example should be adjusted to ensure the calculation does not exceed the limits of double precision floating-point format.\n\n### Corrected Edge Case Example for Maximum Radii\n\n2. **Maximum Radii (Corrected)**: This edge case tests the scenario with large, but not maximum, radii to avoid overflow in the calculation.\n\n    **Example**: `input: \"1e+154 1e+153\"`\n\n### Python3 Code for Generating Test Cases\n\n```python\nimport json\nimport random\n\ndef generate_random_cases(n):\n    cases = []\n    for _ in range(n):\n        r1 = random.uniform(0.0000000000000001, 1e+154)\n        r2 = random.uniform(0.0000000000000001, r1)  # Ensure r2 is always smaller than or equal to r1\n        case = {\"input\": f\"{r1} {r2}\"}\n        cases.append(case)\n    return cases\n\ndef main():\n    edge_cases = [\n        {\"input\": \"0.0000000000000001 0.00000000000000001\"},\n        {\"input\": \"1e+154 1e+153\"},\n        {\"input\": \"5.0 5.0\"},\n        {\"input\": \"100.0 1.0\"},\n        {\"input\": \"5.0001 5.0\"}\n    ]\n    \n    random_cases = generate_random_cases(100)\n    all_cases = edge_cases + random_cases\n    \n    with open('test_cases.json', 'w') as f:\n        json.dump(all_cases, f, indent=4)\n\nif __name__ == \"__main__\":\n    main()\n```\n\nThis Python script generates a JSON file containing the improved edge cases and an additional 100 random test cases within the specified limits."
      response = { "choices": [{ "finish_reason": "stop", "message": { "content": content } }], usage: { prompt_tokens: 875, completion_tokens: 817, total_tokens: 1692 } }
      response.with_indifferent_access
    end

    def python3_unit_tests_fake_response
      content = "Based on the problem description and the provided solution, we need to identify and create test cases that cover various edge scenarios. Let's consider the edge cases based on the input limits and constraints.\n\n### Edge Cases\n\n1. **Empty String**: The input string is empty (`\"\"`). The expected output should also be an empty string.\n2. **Single Character String**: The input string contains only one character (e.g., `\"a\"`). The output should be the same as the input.\n3. **String with All Identical Characters**: The input string contains all identical characters (e.g., `\"aaaaaa\"`). The output should be every other character starting from the first, which would be a string with half the length of the input if the input length is even, or half plus one if the input length is odd.\n4. **String with Alternate Characters**: The input string has a pattern where every alternate character is different (e.g., `\"ababab\"`). The output should be the first of each pair of characters.\n5. **String with Spaces or Special Characters**: The input string includes spaces or special characters (e.g., `\"h e l l o\"`). Spaces and special characters should be treated as normal characters.\n6. **Very Long String**: The input string is very long (but within memory limits). This tests the function's ability to handle large inputs efficiently.\n7. **String with Unicode Characters**: The input string includes Unicode characters (e.g., emojis, characters in different languages).\n8. **String with Numbers and Letters**: The input string includes a mix of numbers and letters (e.g., `\"a1b2c3\"`).\n\n### Reflection\n\nUpon reflection, these edge cases seem to cover a wide range of possibilities for the input string, including various lengths, characters, and types. The cases account for typical scenarios as well as some less common but possible situations, such as strings with special characters or very long strings.\n\n### Revised Edge Cases\n\nAfter reflection, the edge cases appear comprehensive and well-considered. They should sufficiently test the robustness of the function across various input scenarios. \n\n### Unit Test Code\n\nNow, let's create the unit test code in Python. This code will use the `unittest` library and will include tests for the edge cases described above. Additionally, it will include 100 random test cases.\n\n```python\nimport unittest\nimport string\nimport random\nfrom solution import string_bits as tested_solution\n\ndef instructor_solution(str):\n    new_str = \"\"\n    for i in range(0, len(str)):\n        if i % 2 == 0:\n            new_str += str[i]\n    return new_str\n\nclass TestStringBitsFunction(unittest.TestCase):\n\n    def test_empty_string(self):\n        self.assertEqual(tested_solution(\"\"), instructor_solution(\"\"))\n\n    def test_single_character(self):\n        self.assertEqual(tested_solution(\"a\"), instructor_solution(\"a\"))\n\n    def test_identical_characters(self):\n        self.assertEqual(tested_solution(\"aaaaaa\"), instructor_solution(\"aaaaaa\"))\n\n    def test_alternate_characters(self):\n        self.assertEqual(tested_solution(\"ababab\"), instructor_solution(\"ababab\"))\n\n    def test_string_with_spaces(self):\n        self.assertEqual(tested_solution(\"h e l l o\"), instructor_solution(\"h e l l o\"))\n\n    def test_very_long_string(self):\n        long_str = \"a\" * 10000\n        self.assertEqual(tested_solution(long_str), instructor_solution(long_str))\n\n    def test_unicode_characters(self):\n        self.assertEqual(tested_solution(\"🙂🙃🙂🙃🙂\"), instructor_solution(\"🙂🙃🙂🙃🙂\"))\n\n    def test_numbers_letters_mix(self):\n        self.assertEqual(tested_solution(\"a1b2c3\"), instructor_solution(\"a1b2c3\"))\n\n    def test_random_cases(self):\n        for _ in range(100):\n            random_str = ''.join(random.choices(string.ascii_letters + string.digits, k=random.randint(1, 100)))\n            self.assertEqual(tested_solution(random_str), instructor_solution(random_str))\n\nif __name__ == \"__main__\":\n    unittest.main()\n```\n\nNote: The `solution` module should contain the `string_bits` function that we are testing. The `instructor_solution` function is included as a reference to compare against the tested solution.\n"
      response = { "choices": [{ "finish_reason": "stop", "message": { "content": content } }], usage: { prompt_tokens: 724, completion_tokens: 886, total_tokens: 1610 } }
      response.with_indifferent_access
      end

    def c_unit_tests_fake_response
      content = "Based on the provided problem description, let's identify the edge cases to test the palindrome function efficiently. The edge cases will be derived from the Input Format and Limits Sections of the problem. ### Edge Cases to Consider: 1. **Minimum Length String**: Since the input string must have at least one character, the smallest string to test is a single character, which should always be considered a palindrome. 2. **Even Length String**: A string with an even number of characters, such as \"abba\", where mirroring occurs without a central character. 3. **Odd Length String**: A string with an odd number of characters, such as madam\", where there is a central character that does not need to be mirrored. 4. **Not a Palindrome**: Strings that are clearly not palindromes, such as \"abc\", to ensure the function correctly identifies non-palindromic sequences. 5. **All Same Characters**: Strings where all characters are the same, like \"aaaa\", which are trivially palindromes. 6. **Case Sensitivity Check**: Given the problem states the string consists of lowercase alphabetic characters only, there's no need to check for case sensitivity as an edge case in this context. 7. **Maximum Length String**: Testing strings that are at the upper limit of what is practical to process, given the time and space complexity constraints. This limit wasn't explicitly defined, but considering the practical limits of standard programming environments, we could test with strings of significant length, like 1,000 to 10,000 characters, though the specific maximum isn't given. ### Reflection: - The edge cases cover scenarios from the simplest (a single character) to more complex (even and odd length strings). - The problem description does not specify a maximum length for the input string, but it's important to test with large strings to ensure performance remains consistent. - The focus is on lowercase alphabetic characters, eliminating the need to test for uppercase characters or non-alphabetic characters. ### Improved Edge Cases: After reflection, the edge cases seem to appropriately cover the problem's constraints and input limits. There's no indication of a mistake in considering the edge cases based on the provided information. Therefore, no adjustments are necessary. ### C Code for Testing: ```c To create comprehensive edge cases for the given programming problem, we should consider the following based on the problem's Input Format and Limits Sections:\n\n1. **Zero Input:** Testing with 0 as input to ensure that the function correctly handles this edge case, expecting an output of 0.\n2. **Minimum Integer Value:** Test with the minimum int value (-2,147,483,648) to verify how the function handles overflow since doubling this value would exceed the lower limit of a 32-bit signed integer.\n3. **Maximum Integer Value:** Testing with values close to the maximum int value (2,147,483,647) to see if the function correctly handles potential overflow when the doubled value exceeds the upper limit of a 32-bit signed integer.\n4. **Positive Integer:** A test with a standard positive integer that does not cause overflow, such as 1, expecting an output of 2.\n5. **Negative Integer:** A test with a standard negative integer, e.g., -1, to ensure the function correctly doubles negative values, expecting an output of -2.\n6. **Large Positive Integer That Does Not Cause Overflow:** Testing with a large positive integer that is within the range to be safely doubled without causing overflow, for example, 1,073,741,823 (just below the point of overflow).\n7. **Large Negative Integer That Does Not Cause Overflow:** Testing with a large negative integer, such as -1,073,741,823, to ensure it doubles correctly without causing underflow.\n\nReflection on the above edge cases reveals that we must adjust the second and third cases slightly. Specifically:\n\n- The minimum integer value case cannot be directly doubled without causing undefined behavior due to overflow. It's important to note that doubling the minimum value of a signed 32-bit integer is not a valid operation as it exceeds the range of representable values.\n- Similarly, testing with the maximum integer value or values close to it should consider that doubling these values will also result in overflow, which is undefined behavior in many programming languages.\n\nConsidering these reflections, we acknowledge that attempting to double the minimum and maximum integer values directly is not practical for a safe operation within the limits of a 32-bit signed integer. Therefore, we should avoid using the extreme limits of the integer range directly in tests where overflow or underflow is a certainty.\n\nNow, incorporating the reflection feedback into our improved edge cases:\n\n1. **Zero Input:** Unchanged, as it's a valid test case.\n2. **Near Minimum Integer Value without Causing Underflow:** Rather than testing the exact minimum value, we should focus on a value that, when doubled, does not cause underflow. However, since any negative value doubled will remain within the negative range, we are limited by the practicality of doubling negative integers close to the minimum value without hitting the overflow condition.\n3. **Positive and Negative Integers:** These cases remain valid and crucial for testing.\n4. **Large Positive and Negative Integers That Do Not Cause Overflow or Underflow:** These tests remain essential to ensure the function handles large integers correctly within the operational range.\n\nGiven the nature of integer overflow, our test suite must acknowledge that directly testing the doubling of the minimum and maximum 32-bit signed integer values is not feasible without invoking undefined behavior. Instead, our tests will focus on practical integers within the safe operational range and include checks for handling zero and typical positive and negative values. \n\nNext, let's proceed to write the C code with complete unit tests based on these improved edge cases.\n\nBelow is the C code that contains complete unit tests for the doubling function problem, taking into account the discussed edge cases and including 100 random test cases within the safe operational range:\n\n```c\n#include <assert.h>\n#include <time.h>\n#include <stdlib.h>\n#include \"solution.h\"\n\nint referenceSolution(int n) {\n    // Assuming the optimal solution provided in the problem description\n    return 2 * n;\n}\n\nint main() {\n    srand(time(NULL));\n\n    // Zero Input\n    {\n        int input = 0;\n        int toTest = solutionToTest(input);\n        int expected = referenceSolution(input);\n        assert(toTest == expected);\n    }\n\n    // Positive Integer\n    {\n        int input = 1;\n        int toTest = solutionToTest(input);\n        int expected = referenceSolution(input);\n        assert(toTest == expected);\n    }\n\n    // Negative Integer\n    {\n        int input = -1;\n        int toTest = solutionToTest(input);\n        int expected = referenceSolution(input);\n        assert(toTest == expected);\n    }\n\n    // Large Positive Integer That Does Not Cause Overflow\n    {\n        int input = 1073741823;\n        int toTest = solutionToTest(input);\n        int expected = referenceSolution(input);\n        assert(toTest == expected);\n    }\n\n    // Large Negative Integer That Does Not Cause Overflow\n    {\n        int input = -1073741823;\n        int toTest = solutionToTest(input);\n        int expected = referenceSolution(input);\n        assert(toTest == expected);\n    }\n\n    // 100 Random Test Cases\n    for (int i = 0; i < 100; ++i) {\n        int input = rand() % 2147483647; // Ensuring input is within the safe range\n        if (rand() % 2) input = -input; // Randomly choosing positive or negative values\n        int toTest = solutionToTest(input);\n        int expected = referenceSolution(input);\n        assert(toTest == expected);\n    }\n\n    return 0;\n}\n```\n\nThis test suite includes checks for:\n- Zero input.\n- A standard positive integer.\n- A standard negative integer.\n- Large positive and negative integers that are safe from causing overflow or underflow.\n- 100 additional random test cases within the operational range to ensure robustness.\n\nNote: The random test cases are generated within the maximum range of positive 32-bit integers. A random decision is made to either keep this value positive or make it negative to ensure a wide variety of test cases. This approach avoids direct testing of overflow and underflow edge cases, which are not practical for a function expected to operate within the limits of a 32-bit signed integer.\n ``` This code includes the necessary libraries and assumes the presence of \"solution.c\" as per the instructions. It tests the edge cases identified and includes 100 random test cases within the defined input limits. Each test case is isolated in its scope, and the output of the `IsPalindrome` function is printed, followed by a separator."
      response = { "choices": [{ "finish_reason": "stop", "message": { "content": content } }], usage: { prompt_tokens: 850, completion_tokens: 925, total_tokens: 1775 } }
      response.with_indifferent_access
    end

    def c_unit_tests_matching_fake_response
      content = "### Edge Case Descriptions\n\n1. **Minimum Length Input:** A string of length 1 (e.g., \"a\"). This tests the function's handling of the smallest possible input, which is always a palindrome by definition.\n2. **Even Length Palindrome:** A string of even length where the first half is the mirror image of the second half (e.g., \"abba\"). This tests the function's ability to correctly identify palindromes of even lengths.\n3. **Odd Length Palindrome:** A string of odd length where the first half is the mirror image of the second half, excluding the middle character (e.g., \"racecar\"). This tests the function's ability to correctly identify palindromes of odd lengths.\n4. **Non-Palindrome Short String:** A short string that is not a palindrome (e.g., \"ab\"). This tests the function's ability to correctly identify non-palindromic short strings.\n5. **Non-Palindrome Long String:** A longer string that is not a palindrome (e.g., \"character\"). This tests the function's ability to correctly identify non-palindromic longer strings.\n6. **Case with All Same Characters:** A string where all characters are the same (e.g., \"aaaa\"). This tests the function's handling of a special but trivial case of a palindrome.\n7. **Maximum Length Input:** A string that is at the upper limit of the problem's constraints, if specified. Since the limits section does not specify a maximum length, this case will assume a reasonable upper limit based on standard programming environments, such as a string close to the maximum size that can be handled comfortably by the environment (e.g., 1000 characters). However, without a specific limit provided, this test case focuses on ensuring the algorithm can handle large inputs efficiently within its time and space complexity constraints.\n\n### Reflection\n\nThe described edge cases cover a wide range of scenarios: the minimal input scenario, even and odd length palindromes, non-palindromes of varying lengths, a trivial case of a palindrome, and a stress test with a large input size. However, there are a couple of considerations to address:\n\n- The assumption for the \"Maximum Length Input\" may not precisely match the environment's actual constraints, as these were not explicitly defined in the problem statement. It would be more accurate to focus on typical constraints encountered in practice, ensuring the tests remain relevant and feasible.\n- There's no explicit test case for strings with only two characters, one being a palindrome (e.g., \"aa\") and one not (e.g., \"ab\"), which might seem redundant but could serve as a basic check for the algorithm's handling of the simplest non-trivial palindromes and non-palindromes.\n\n### Adjusted Edge Case Descriptions\n\n1. **Minimum Length Input:** Unchanged, as it adequately tests the smallest input scenario.\n2. **Even Length Palindrome:** Unchanged, as it effectively tests even length palindromes.\n3. **Odd Length Palindrome:** Unchanged, as it effectively tests odd length palindromes.\n4. **Non-Palindrome Short String:** Unchanged, as it effectively tests the algorithm's ability to identify short non-palindromes.\n5. **Non-Palindrome Long String:** Unchanged, as it effectively tests the algorithm's ability to identify long non-palindromes.\n6. **Case with All Same Characters:** Unchanged, as it tests a trivial case of palindromes effectively.\n7. **Two Character String, Palindrome:** A string of two identical characters (e.g., \"cc\"). This tests the function's ability to recognize the simplest non-trivial palindrome.\n8. **Two Character String, Non-Palindrome:** A string of two different characters (e.g., \"cd\"). This tests the function's ability to recognize the simplest non-trivial non-palindrome.\n9. **Maximum Length Input:** While the original description remains valid, it's clarified that this test should ensure the algorithm's performance within practical limits, such as handling strings efficiently up to lengths that are common in standard environments without specifying an exact number.\n\n### C Code to Test the Problem\n\n```c\n#include <stdio.h>\n#include <ctype.h>\n#include <string.h>\n#include <stdbool.h>\n#include <math.h>\n#include <time.h>\n#include <stdlib.h>\n#include \"solution.c\"\n\nchar SEPARATOR[] = \"#<ab@17943918\#@>#\";\n\nint main() {\n    srand(time(NULL));\n\n    {\n        // Test 1: Minimum Length Input\n        char word[] = \"a\";\n        printf(\"%d\\n\", IsPalindrome(word));\n        printf(\"%s\\n\", SEPARATOR);\n    }\n\n    {\n        // Test 2: Even Length Palindrome\n        char word[] = \"abba\";\n        printf(\"%d\\n\", IsPalindrome(word));\n        printf(\"%s\\n\", SEPARATOR);\n    }\n\n    {\n        // Test 3: Odd Length Palindrome\n        char word[] = \"racecar\";\n        printf(\"%d\\n\", IsPalindrome(word));\n        printf(\"%s\\n\", SEPARATOR);\n    }\n\n    {\n        // Test 4: Non-Palindrome Short String\n        char word[] = \"ab\";\n        printf(\"%d\\n\", IsPalindrome(word));\n        printf(\"%s\\n\", SEPARATOR);\n    }\n\n    {\n        // Test 5: Non-Palindrome Long String\n        char word[] = \"character\";\n        printf(\"%d\\n\", IsPalindrome(word));\n        printf(\"%s\\n\", SEPARATOR);\n    }\n\n    {\n        // Test 6: Case with All Same Characters\n        char word[] = \"aaaa\";\n        printf(\"%d\\n\", IsPalindrome(word));\n        printf(\"%s\\n\", SEPARATOR);\n    }\n\n    {\n        // Test 7: Two Character String, Palindrome\n        char word[] = \"cc\";\n        printf(\"%d\\n\", IsPalindrome(word));\n        printf(\"%s\\n\", SEPARATOR);\n    }\n\n    {\n        // Test 8: Two Character String, Non-Palindrome\n        char word[] = \"cd\";\n        printf(\"%d\\n\", IsPalindrome(word));\n        printf(\"%s\\n\", SEPARATOR);\n    }\n\n    // Additional 100 random test cases\n    for (int i = 0; i < 100; i++) {\n        int len = rand() % 20 + 1; // Generating strings of length 1 to 20\n        char word[len + 1];\n        for (int j = 0; j < len; j++) {\n            word[j] = 'a' + rand() % 26; // Generating lowercase alphabetic characters\n        }\n        word[len] = '\\0'; // Null-terminating the string\n        printf(\"%d\\n\", IsPalindrome(word));\n        printf(\"%s\\n\", SEPARATOR);\n    }\n\n    return 0;\n}\n```\n\nThis C code includes the necessary libraries and follows the guidelines provided for testing the problem with both the specified edge cases and additional random test cases. The random tests ensure a broad coverage of scenarios within the constraints defined in the Input Format and Limits Sections.\n"
      response = { "choices": [{ "finish_reason": "stop", "message": { "content": content } }], usage: { prompt_tokens: 850, completion_tokens: 1231, total_tokens: 2081 } }
      response.with_indifferent_access
    end
  end
end