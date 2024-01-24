module CodeRunner
  class ParserTestCase
    attr_accessor :input, :output, :code

    def initialize(input, output, code)
      @input = input
      @output = output
      @code = code
    end
  end
end