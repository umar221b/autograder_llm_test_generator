module CodeRunner
  class StdinTestCase
    attr_accessor :input, :output

    def initialize(input, output)
      @input = input
      @output = output
    end

    def test
      @input
    end

    def to_s
      "Input:\n#{@input}\nOutput:\n#{@output}"
    end
  end
end