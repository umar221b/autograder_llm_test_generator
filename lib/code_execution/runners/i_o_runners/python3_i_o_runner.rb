require 'code_execution/runners/i_o_runner'

module CodeExecution
  class Python3IORunner < IORunner

  private
    def prepare; end

    def code_file
      'tmp/code.py'.freeze
    end

    def clean
      super
      %x( rm #{code_file} )
    end
  end
end