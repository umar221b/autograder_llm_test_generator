require 'code_execution/runners/basic_runner'

module CodeExecution
  class BasicPython3Runner < BasicRunner

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