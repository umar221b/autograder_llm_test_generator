require 'code_execution/misc_models/input_output_test_case'

module CodeExecution
  class BasicRunner
    ERROR_FILE = 'tmp/error.txt'.freeze

    attr_reader :reference_solution, :inputs

    def initialize(reference_solution, inputs)
      @reference_solution = reference_solution
      @inputs = inputs
    end

    def generate_test_outputs
      create_code_file
      write_to_code_file(@reference_solution)
      close_code_file

      prepare

      tests = []
      @inputs.each do |input_json|
        stdin = input_json['input']
        write_input(stdin)
        run
        stdout = read_output
        stderr = read_error
        tests << CodeExecution::InputOutputTestCase.new(stdin, stdout, stderr)
      end

      clean

      tests
    end

  private

    def prepare
      raise NotImplementedError, 'Implement the method prepare in a subclass to prepare the code (e.g., compile it)'
    end

    def run
      raise NotImplementedError, 'Implement the method run in a subclass to run the code'
    end

    def code_file
      raise NotImplementedError, 'Implement the method code_file in a subclass to define the code filename'
    end

    def input_file
      raise NotImplementedError, 'Implement the method input_file in a subclass to define the input filename'
    end

    def output_file
      raise NotImplementedError, 'Implement the method output_file in a subclass to define the output filename'
    end

    def create_code_file
      @file = File.new(code_file, 'w')
    end

    def write_to_code_file(data_to_write)
      @file.write(data_to_write)
    end

    def close_code_file
      @file.close
    end

    def write_input(input)
      %x( echo #{input} > #{input_file})
    end

    def read_output
      %x( cat #{output_file} )
    end

    def read_error
      %x( cat #{ERROR_FILE} )
    end

    def clean
      %x( rm #{input_file} #{output_file} #{ERROR_FILE} )
    end
  end
end