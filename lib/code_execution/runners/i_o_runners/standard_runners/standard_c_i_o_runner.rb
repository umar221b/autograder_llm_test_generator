require 'code_execution/runners/i_o_runners/c_i_o_runner'

module CodeExecution
  class StandardCIORunner < CIORunner

  private
    def run
      %x( ./#{RUNGUARD} -C 6 -o #{file_path(output_file)} -e #{file_path(ERROR_FILE)} #{file_path(OBJECT_FILE)} <#{file_path(input_file)} 2>#{file_path(RUNGUARD_ERROR)} )
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