require 'nokogiri'
require 'code_runner/models/question'

module CodeRunner
  class Parser
    class << self
      def parse_xml_document(file_path)
        File.open(file_path) { |f| Nokogiri::XML(f) }
      end

      def extract_questions(document)
        document.xpath('/quiz/question')
      end

      def extract_question_title(question)
        question.at_xpath('name/text')
      end

      def extract_question_statement(question)
        question.at_xpath('questiontext/text')
      end

      def extract_question_type(question)
        question.at_xpath('coderunnertype')
      end

      def extract_question_answer(question)
        question.at_xpath('answer')
      end

      def extract_question_test_cases(question)
        question.xpath('//testcase')
      end

      def extract_test_case_stdin(test_case)
        test_case.xpath('stdin/text')
      end

      def extract_test_case_code(test_case)
        test_case.xpath('testcode/text')
      end

      def extract_test_case_expected_output(test_case)
        test_case.xpath('expected/text')
      end
    end

    attr_writer :document
    attr_reader :questions

    def initialize(file_path)
      @document = Parser.parse_xml_document(file_path)
      prepare_problem_from_document
    end

    def prepare_problem_from_document
      xml_questions = Parser.extract_questions(@document)
      @questions = []
      xml_questions.each do |xml_question|
        @questions << Question.new(xml_question)
      end
    end
  end
end