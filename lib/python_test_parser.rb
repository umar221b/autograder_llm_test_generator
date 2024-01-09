class PythonTestParser
  attr_reader :code

  REFERENCE_SOL_METHOD = 'reference_solution'.freeze
  IMPORTS_REGEX = /(from.+|import.+)/
  CLASS_REGEX = /class.+/
  METHOD_NAMES_REGEX = /def\s(\S+)\(/
  MAIN_REGEX = /(if __name__[\S\s]+)/

  class << self
    def imports(code)
      code.scan(IMPORTS_REGEX).flatten
    end

    def class_definition(code)
      code.match(CLASS_REGEX)[0]
    end

    def method_names(code)
      code.scan(METHOD_NAMES_REGEX).flatten
    end

    def method_code(code, method_name)
      matches = code.match(method_code_regex(method_name))
      matches ? matches[1] : nil
    end

    def uncommented_method_code(code, method_name)
      remove_comments(method_code(code, method_name))
    end

    def main(code)
      code.match(MAIN_REGEX)[1]
    end

    def reference_solution(code)
      uncommented_method_code(code, REFERENCE_SOL_METHOD)
    end

    private

    def method_code_regex(method)
      /([ \t]*def #{method}[\s\S]+?)([ ]+def|if __name__|class)/
    end

    def remove_comments(code)
      return nil unless code

      code.gsub(/[ \t]+#.+\n/, '')
    end
  end

  def initialize(source, path = false)
    @code = path ? File.read(source): source
  end

  def method_codes
    return @method_codes if @method_codes

    @method_codes = {}
    method_names.each do |method_name|
      @method_codes[method_name] = PythonTestParser.uncommented_method_code(@code, method_name)
    end
    @method_codes
  end

  def method_dependencies
    return @method_dependencies if @method_dependencies

    @method_dependencies = {}
    method_names.each do |non_test_method_name|
      next if non_test_method_name.start_with?('test_') || non_test_method_name == REFERENCE_SOL_METHOD # only work on non-test methods
      method_names.each do |method_name|
        next if non_test_method_name == method_name  # method cannot be a dependant of itself
        if method_codes[method_name].include?(non_test_method_name)
          @method_dependencies[method_name] = [] unless @method_dependencies[method_name]
          @method_dependencies[method_name] << non_test_method_name
        end
      end
    end
    @method_dependencies
  end

  def imports
    @imports ||= PythonTestParser.imports(@code)
  end

  def class_definition
    @class_definition ||= PythonTestParser.class_definition(@code)
  end

  def method_names
    @method_names ||= PythonTestParser.method_names(@code)
  end

  def method_code(method_name)
    PythonTestParser.method_code(@code, method_name)
  end

  def uncommented_method_code(method_name)
    method_codes[method_name]
  end

  def main
    @main ||= PythonTestParser.main(@code)
  end

  def reference_solution
    @reference_solution ||= uncommented_method_code('reference_solution')
  end

  def full_test_method_code(method_name)
    return nil unless method_names.include?(method_name)

    all_test_method_codes = [uncommented_method_code(method_name)]

    if method_dependencies.key?(method_name)
      method_dependencies[method_name].each do |dependant_on_method|
        all_test_method_codes << uncommented_method_code(dependant_on_method)
      end
    end


    imports.join("\n") + "\n" + reference_solution + "\n" + class_definition + "\n" + all_test_method_codes.join("\n") + "\n" + main
  end

  def build_tests()
    return nil unless method_names.include?(method_name)

    all_test_method_codes = [uncommented_method_code(method_name)]

    if method_dependencies.key?(method_name)
      method_dependencies[method_name].each do |dependant_on_method|
        all_test_method_codes << uncommented_method_code(dependant_on_method)
      end
    end


    imports.join("\n") + "\n" + reference_solution + "\n" + class_definition + "\n" + all_test_method_codes.join("\n") + "\n" + main
  end
end