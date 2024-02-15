require 'code_execution/runners/i_o_runners/c_i_o_runner'

module CodeExecution
  class StandardCIORunner < CIORunner

  private
    def run
      puts "Running #{file_path(OBJECT_FILE)}.."
      %x( ./#{RUNGUARD} -C 5 -o #{file_path(output_file)} -e #{file_path(ERROR_FILE)} #{file_path(OBJECT_FILE)} <#{file_path(input_file)} 2>#{file_path(RUNGUARD_ERROR)} )
      puts "Finished running #{file_path(OBJECT_FILE)}.."
    end

    # TODO: Move to a parent class
    def input_file
      'input.txt'.freeze
    end

    def output_file
      'output.txt'.freeze
    end
  end
end