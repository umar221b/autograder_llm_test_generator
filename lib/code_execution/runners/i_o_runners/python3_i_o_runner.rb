require 'code_execution/runners/i_o_runner'

module CodeExecution
  class Python3IORunner < IORunner

  private
    def prepare
      [] # no preparation so no errors
    end

    def code_file
      'code.py'.freeze
    end

    def clean
      super
      %x( rm #{file_path(code_file)} )
    end
  end
end