require 'code_execution/runners/i_o_runner'

module CodeExecution
  class CIORunner < IORunner
    OBJECT_FILE = 'tmp/code'.freeze

  private
    def prepare
      %x( gcc #{code_file} -o #{OBJECT_FILE} -lm )
    end

    def code_file
      'tmp/code.c'.freeze
    end

    def clean
      super
      %x( rm #{code_file} #{OBJECT_FILE} )
    end
  end
end