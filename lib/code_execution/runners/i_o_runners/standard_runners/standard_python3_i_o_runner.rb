require 'code_execution/runners/i_o_runners/python3_i_o_runner'

module CodeExecution
  class StandardPython3IORunner < Python3IORunner

  private

    def run
      %x( python3 #{file_path(code_file)} <#{file_path(input_file)} >#{file_path(output_file)} 2>#{file_path(ERROR_FILE)} )
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