require 'code_runner/models/test_case'

module CodeRunner
  class Question
    attr_reader :problem_title
    attr_reader :problem_statement
    attr_reader :problem_type
    attr_reader :reference_solution
    attr_reader :test_cases

    def initialize(xml_question)
      @problem_title = Parser.extract_question_title(xml_question)
      @problem_statement = Parser.extract_question_statement(xml_question)
      @problem_type = Parser.extract_question_type(xml_question)
      @reference_solution = Parser.extract_question_answer(xml_question)
      test_cases = Parser.extract_question_test_cases(xml_question)
      @test_cases = []
      test_cases.each do |test_case|
        input = Parser.extract_test_case_stdin(test_case)
        output = Parser.extract_test_case_expected_output(test_case)
        @test_cases << TestCase.new(input, output)
      end
    end
  end
end