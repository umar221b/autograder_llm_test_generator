require 'code_runner/constants'

module CodeRunner
  class CodeTestCase
    attr_accessor :code, :output

    def initialize(problem_type, code, output)
      @problem_type = problem_type
      @code = code
      @output = output
    end

    def full_test_code(student_answer)
      sub_hash = {}

      case @problem_type
      when Constants::TYPE_C_FUNCTION
        template = c_function_template
        sub_hash["{{ STUDENT_ANSWER }}"] = student_answer
        sub_hash["{{ TEST_CASE }}"] = @code
      end

      regex = /{{ [A-Z_]+ }}/
      template.gsub(regex, sub_hash)
    end

    def test
      @code
    end

    def to_s
      "Code:\n#{@code}\nOutput:\n#{@output}"
    end

  private
    def c_function_template
      <<-TEXT
      #include <stdio.h>
      #include <stdlib.h>
      #include <ctype.h>
      #include <string.h>
      #include <stdbool.h>
      #include <math.h>

      {{ STUDENT_ANSWER }}

      int main() {
        {{ TEST_CASE }}
        return 0;
      }
      TEXT
    end
  end
end