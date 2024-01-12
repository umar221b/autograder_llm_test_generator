module CodeExecution
  class InputOutputTestCase
    attr_accessor :input, :output, :error

    def initialize(input, output = nil, error = nil)
      @input = input
      @output = output
      @error = error
    end

    def has_error?
      error.present?
    end

    def to_s
      "Input:\n#{@input}\nOutput:\n#{@output}"
    end
  end
end