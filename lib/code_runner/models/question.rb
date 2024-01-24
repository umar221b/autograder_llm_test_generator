require 'code_runner/parser'
require 'code_runner/models/stdin_test_case'
require 'code_runner/models/code_test_case'
require 'code_runner/constants'

module CodeRunner
  class Question
    attr_reader :problem_title
    attr_reader :problem_statement
    attr_reader :problem_type
    attr_reader :reference_solution
    attr_reader :test_cases

    def initialize(xml_question)
      @problem_title = Parser.extract_question_title(xml_question)&.inner_html
      @problem_statement = Parser.extract_question_statement(xml_question)&.inner_html
      @problem_type = Parser.extract_question_type(xml_question)&.inner_html
      @reference_solution = Parser.extract_question_answer(xml_question)&.inner_html
      test_cases = Parser.extract_question_test_cases(xml_question)
      @test_cases = []
      test_cases.each do |test_case|
        case @problem_type
        when Constants::TYPE_C_PROGRAM
          @test_cases << StdinTestCase.new(test_case)
        when Constants::TYPE_C_FUNCTION
          @test_cases << CodeTestCase.new(@problem_type, test_case)
        end
      end
    end
  end
end