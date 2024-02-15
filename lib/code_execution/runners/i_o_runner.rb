require 'code_execution/models/input_output_test_case'
require 'hashing'
require 'code_execution/errors'

module CodeExecution
  class IORunner
    ERROR_FILE = 'error.txt'.freeze
    RUNGUARD = 'tmp/code_execution/runguard'.freeze
    RUNGUARD_ERROR = 'runguard_error.txt'.freeze

    attr_reader :code, :inputs

    def initialize(code, inputs, extra_files = {})
      @code = code
      @inputs = inputs
      @dir_name = Hashing.hash_code(@code)[0..4] + SecureRandom.urlsafe_base64
      @unique_dir = "tmp/code_execution/#{@dir_name}"
      Dir.mkdir(@unique_dir)
      @extra_files = extra_files
    end

    def generate_test_outputs
      tests = []

      puts "Writing to file #{file_path(code_file)}.."
      write_file(code_file, @code)

      preparation_errors = prepare

      if preparation_errors.present? && preparation_errors[0].present?
        puts "======="
        puts "File: #{file_path(code_file)}"
        puts preparation_errors
        puts "======="
        clean
        raise PreparationError, "Solution preparation failed: #{preparation_errors.join(', and ')}"
      end

      @inputs.each do |input_json|
        stdin = input_json['input']
        puts "Writing test case #{input_file} for #{file_path(code_file)}"
        write_file(input_file, stdin)

        run

        puts "Reading output for #{file_path(code_file)}"
        stdout = read_output
        puts "Reading errors for #{file_path(code_file)}"
        stderr = read_error + "\n" + read_runguard_error
        tests << CodeExecution::InputOutputTestCase.new(stdin, stdout, stderr)
      end

      clean

      tests
    end

    def file_path(file)
      "tmp/code_execution/#{@dir_name}/#{file}"
    end

  private

    def prepare
      raise NotImplementedError, 'Implement the method prepare in a subclass to prepare the code (e.g., compile it), returns an array of errors if preparation was not complete and code should not be run'
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

    def write_file(filename, data_to_write)
      file = File.new(file_path(filename), 'w')
      file.write(data_to_write)
      file.close
    end

    def read_output
      %x( cat #{file_path(output_file)} )
    end

    def read_error
      %x( cat #{file_path(ERROR_FILE)} )
    end

    def read_runguard_error
      %x( cat #{file_path(RUNGUARD_ERROR)} )
    end

    def clean
      %x( rm -rf #{file_path('')} )
    end
  end
end