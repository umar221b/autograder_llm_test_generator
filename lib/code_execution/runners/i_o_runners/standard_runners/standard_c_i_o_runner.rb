require 'code_execution/runners/i_o_runners/c_i_o_runner'

module CodeExecution
  class StandardCIORunner < CIORunner

  private
    def run
      %x( ./#{OBJECT_FILE} <#{input_file} >#{output_file} 2>#{ERROR_FILE} )
    end

    # TODO: Move to a parent class
    def input_file
      'tmp/input.txt'.freeze
    end

    def output_file
      'tmp/output.txt'.freeze
    end
  end
end