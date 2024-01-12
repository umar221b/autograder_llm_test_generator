module CodeExecution
  class UnitTestRunner
    OUTPUT_FILE = 'tmp/output.txt'.freeze
    ERROR_FILE = 'tmp/error.txt'.freeze

    attr_reader :unit_test_code

    def initialize(unit_test_code, solution_to_test)
      @unit_test_code = unit_test_code
      @solution_to_test = solution_to_test
    end

    def run_unit_tests
      write_file(unit_test_file, @unit_test_code)
      write_file(solution_to_test_file, @solution_to_test)

      prepare

      run

      failed_tests = extract_failed_tests

      clean

      failed_tests
    end

  private

    def prepare
      raise NotImplementedError, 'Implement the method prepare in a subclass to prepare the code (e.g., compile it)'
    end

    def run
      raise NotImplementedError, 'Implement the method run in a subclass to run the code'
    end

    def unit_test_file
      raise NotImplementedError, 'Implement the method unit_test_file in a subclass to define the unit testing code filename'
    end

    def solution_to_test_file
      raise NotImplementedError, 'Implement the method student_solution_file in a subclass to define the student solution filename'
    end

    def extract_failed_tests
      raise NotImplementedError, 'Implement the method extract_failed_tests in a subclass to extract failed tests'
    end

    def write_file(filename, data_to_write)
      file = File.new(filename, 'w')
      file.write(data_to_write)
      file.close
    end

    def read_output
      %x( cat #{OUTPUT_FILE} )
    end

    def read_error
      %x( cat #{ERROR_FILE} )
    end

    def clean
      %x( rm #{OUTPUT_FILE} #{ERROR_FILE} )
    end
  end
end