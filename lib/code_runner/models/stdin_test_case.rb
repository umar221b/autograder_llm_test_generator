require 'code_runner/parser'

module CodeRunner
  class StdinTestCase
    attr_accessor :input, :output

    def initialize(xml_test_case)
      @input = Parser.extract_test_case_stdin(xml_test_case)&.inner_html
      @output = Parser.extract_test_case_expected_output(xml_test_case)&.inner_html
    end

    def to_s
      "Input:\n#{@input}\nOutput:\n#{@output}"
    end
  end
end