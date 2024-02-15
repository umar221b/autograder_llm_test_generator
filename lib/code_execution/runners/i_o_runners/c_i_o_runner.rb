require 'code_execution/runners/i_o_runner'

module CodeExecution
  class CIORunner < IORunner
    OBJECT_FILE = 'code'.freeze
    COMPILATION_FILE = 'compilation.log'.freeze

  private
    def prepare
      puts "Adding extra files - if any.."
      @extra_files.each do |filename, content|
        write_file(filename, content)
      end

      puts "Compiling #{file_path(code_file)}.."
      compilation_errors_file = file_path(COMPILATION_FILE)
      %x( gcc #{file_path(code_file)} -o #{file_path(OBJECT_FILE)} -lm 2>#{compilation_errors_file})
      compilation_errors = []
      compilation_errors << %x( cat #{compilation_errors_file} )
      compilation_errors
    end

    def code_file
      'code.c'.freeze
    end
  end
end