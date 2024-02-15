# TODO: Parse individual tests and run them

class CTestParser
  attr_reader :code

  PREPROCESSORS_REGEX = /(#include.+|#define.+)/
  GLOBALS_REGEX = /^(?!typedef )(\w+\s*\*?\s+\w+(?:\[\w*\])?(?:\s*=|;)\S*.*;)/
  METHOD_NAMES_REGEX = /^(?!typedef )\w+\s*\*?\s+(\w+)(\[\w*\])?\(/
  MAIN_REGEX = /((?!typedef )(?:\w+\s*\*?\s+)+main(?:\[\w*\])?\((?:\s|.)*?[\s\S]*)/
  IN_MAIN_BEFORE_TESTS_REGEX = /srand\(time\(NULL\)\);\n([\S\s]+?)\s+printf\("Test starting\\n"\);/
  COMMENTS_REGEX = /([ \t]+\/\/.+|\/\*[^*]*\*+(?:[^\/*][^*]*\\*+)*\/)/
  TEST_REGEX = /printf\("Test starting\\n"\);\n([\S\s]+?)^\s*printf\("Test ending\\n"\);/
  RANDOM_TESTS_REGEX = /printf\("Random tests starting\\n"\);\n([\S\s]+?)^\s*printf\("Random tests ending\\n"\);/

  class << self
    def pre_processors(code)
      code.scan(PREPROCESSORS_REGEX).flatten
    end

    def globals(code)
      code.scan(GLOBALS_REGEX).flatten
    end

    def auxiliary_method_names(code)
      all_auxiliary_method_names = code.scan(METHOD_NAMES_REGEX).flatten
      all_auxiliary_method_names.delete('main')
      all_auxiliary_method_names.compact
    end

    def uncommented_auxiliary_method_code(code, method_name)
      if method_name == 'main'
        throw StandardError, "Use the method 'main' to extract the main function's code"
      end

      uncommented_code = remove_comments(code)
      match = uncommented_code&.match(uncommented_auxiliary_method_code_regex(method_name))
      match[1] if match.present?
    end

    def main(code)
      remove_comments(code)&.match(MAIN_REGEX)[1]
    end

    def in_main_before_tests(code)
      main(code)&.match(IN_MAIN_BEFORE_TESTS_REGEX)[1]
    end

    def tests(code)
      all_random_tests = random_tests(code)

      # add random seed to random tests
      all_random_tests.each do |random_test|
        random_number = Time.now.to_i % 1_000_000_007
        random_test = "srand(#{random_number});\n" + random_test
      end

      non_random_tests = []
      main(code).scan(TEST_REGEX).flatten.each do |test|
        add = true
        all_random_tests.each do |random_test|
          if random_test.include?(test)
            add = false
            break
          end
        end
        non_random_tests << test if add
      end
      non_random_tests
    end

    def random_tests(code)
      main(code).scan(RANDOM_TESTS_REGEX).flatten
    end

    private

    def uncommented_auxiliary_method_code_regex(method_name)
      /((?:int\s|void\s|string\s|double\s|float\s|char\s)#{method_name}[\s\S]+?)\n+(?:(?:int\s|void\s|string\s|double\s|float\s|char\s)|\Z)/
    end

    def remove_comments(code)
      return nil unless code

      code.gsub(COMMENTS_REGEX, '')
    end
  end

  def initialize(source, path = false)
    @code = path ? File.read(source): source
  end

  def uncommented_auxiliary_method_codes
    return @uncommented_auxiliary_method_codes if @uncommented_auxiliary_method_codes

    @uncommented_auxiliary_method_codes = []
    auxiliary_method_names.each do |method_name|
      @uncommented_auxiliary_method_codes << CTestParser.uncommented_auxiliary_method_code(@code, method_name)
    end
    @uncommented_auxiliary_method_codes
  end

  def pre_processors
    @pre_processors ||= CTestParser.pre_processors(@code)
  end

  def globals
    @globals ||= CTestParser.globals(@code)
  end

  def auxiliary_method_names
    @auxiliary_method_names ||= CTestParser.auxiliary_method_names(@code)
  end

  def uncommented_auxiliary_method_code(method_name)
    CTestParser.uncommented_auxiliary_method_code(@code, method_name)
  end

  def main
    @main ||= CTestParser.main(@code)
  end

  def in_main_before_tests
    main&.match(IN_MAIN_BEFORE_TESTS_REGEX)[1]
  end

  def tests
    CTestParser.tests(@code)
  end

  def random_tests
    CTestParser.random_tests(@code)
  end

  def single_test_code(test)
    pre_processors.join("\n") + "\n" + globals.join("\n") + "\n" + uncommented_auxiliary_method_codes.join("\n") + "\n#include \"solution.c\"\n" + "int main() {\n    srand(time(NULL));\n" + in_main_before_tests + "\n" + test + "\n    return 0;\n}"
  end

  def full_test_code
    @code
  end
end