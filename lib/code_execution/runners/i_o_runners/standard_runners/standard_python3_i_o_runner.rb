require 'code_execution/runners/i_o_runners/python3_i_o_runner'

module CodeExecution
  class StandardPython3IORunner < Python3IORunner

  private

    def run
      %x( python3 #{code_file} <#{input_file} >#{output_file} 2>#{ERROR_FILE} )
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