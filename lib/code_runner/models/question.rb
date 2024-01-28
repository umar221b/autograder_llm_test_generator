require 'code_runner/constants'
require 'code_runner/parser'
require 'code_runner/models/parser_test_case'
require 'code_runner/models/stdin_test_case'
require 'code_runner/models/code_test_case'

module CodeRunner
  class Question
    attr_reader :problem_title
    attr_reader :problem_statement
    attr_reader :problem_type
    attr_reader :reference_solution
    attr_reader :test_cases

    def initialize(xml_question, combine_cases)
      @problem_title = Parser.extract_question_title(xml_question)&.inner_html
      @problem_statement = Parser.extract_question_statement(xml_question)&.inner_html
      @problem_type = Parser.extract_question_type(xml_question)&.inner_html
      @reference_solution = Parser.extract_question_answer(xml_question)&.inner_html
      test_cases = Parser.extract_question_test_cases(xml_question)
      test_cases = parse_test_cases_from_xml(test_cases)

      test_cases = combine_test_cases(test_cases) if combine_cases

      @test_cases = prepare_test_cases(test_cases)
    end

    def programming_language
      case @problem_type
      when Constants::TYPE_C_PROGRAM, Constants::TYPE_C_FUNCTION
        Constants::PROGRAMMING_LANGUAGE_C
      end
    end

  private

    def parse_test_cases_from_xml(xml_test_cases)
      xml_test_cases.map do |test_case|
        input = Parser.extract_test_case_stdin(test_case)&.inner_html
        output = Parser.extract_test_case_expected_output(test_case)&.inner_html
        code = Parser.extract_test_case_code(test_case)&.inner_html
        ParserTestCase.new(input, output, code)
      end
    end

    def combine_test_cases(test_cases)
      input = ""
      output = ""
      code = ""
      test_cases.each_with_index do |test_case, index|
        last = index == test_cases.size - 1

        if test_case.input
          input += "\n#{test_case.input}"
          input += "\n#{Constants::SEPARATOR}" unless last
        end

        if test_case.output
          output += "\n#{test_case.output}"
          output += "\n#{Constants::SEPARATOR}" unless last
        end

        if test_case.code
          if  Constants::TYPE_C_FUNCTION
            code += "\n{\n#{test_case.code}\n}"
            break if last

            code += "\nprintf(\"#{Constants::SEPARATOR}\\n\");\n"
          end
        end
      end
      [ParserTestCase.new(input, output, code)]
    end
    def prepare_test_cases(test_cases)
      cases = []
      test_cases.each do |test_case|
        case @problem_type
        when Constants::TYPE_C_PROGRAM
          cases << StdinTestCase.new(test_case.input, test_case.output)
        when Constants::TYPE_C_FUNCTION
          cases << CodeTestCase.new(@problem_type, test_case.code, test_case.output)
        end
      end
      cases
    end
  end
end