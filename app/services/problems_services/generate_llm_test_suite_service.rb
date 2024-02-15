require 'json'
require 'code_execution'
require 'c_test_parser'

module ProblemsServices
  class GenerateLlmTestSuiteService < ApplicationService
    def initialize(llm_chat_query)
      @llm_chat_query = llm_chat_query
      @problem = @llm_chat_query.problem
      @please_create = true
    end

    def perform
      if @please_create
        @test_suite = @problem.test_suites.new(generated_by: TestSuite::GENERATED_BY_LLM, llm_chat_query: @llm_chat_query)
        unless @test_suite.save
          errors.merge!(@test_suite.errors)
          return
        end
      end

      @reference_solution = @problem.reference_solution

      case @problem.test_type
      when Problem::TEST_TYPE_MATCHING_OUTPUTS
        handle_matching_outputs
      when Problem::TEST_TYPE_PYTHON3_UNIT_TESTS
        handle_python3_unit_tests
      when Problem::TEST_TYPE_C_UNIT_TESTS
        handle_c_unit_tests
      when Problem::TEST_TYPE_C_UNIT_TESTS_MATCHING
        handle_c_unit_tests_matching
      else
        errors.add(:base, 'Invalid problem test type')
        return
      end
    end

  private

    def handle_matching_outputs
      test_case_generator_code = @llm_chat_query.python_code
      if test_case_generator_code.present? || @llm_chat_query.no_inputs?
        if test_case_generator_code.present?
          code_filename = 'test_case_generator.py'
          write_file('tmp/services/' + code_filename, test_case_generator_code)
          run_python3(code_filename)

          inputs_json_string = read_file('test_cases.json')
          inputs_json = JSON.parse(inputs_json_string)
        else
          inputs_json = [{ 'input': ''}]
        end

        runner = CodeExecution::StandardCIORunner.new(@reference_solution, inputs_json)
        test_cases = runner.generate_test_outputs

        test_cases.each do |test_case|
          puts test_case
          puts "================"
          if test_case.has_error?
            puts test_case.error
            if @please_create
              @test_suite.test_cases.create(
                test: test_case.input,
                reference_solution_errors: test_case.error, rejected: true
              )
            end
          else
            if @please_create
              @test_suite.test_cases.build(test: test_case.input, expected_output: test_case.output)
            end
          end
        end

        if @please_create
          unless @test_suite.save
            errors.merge!(@test_suite.errors)
            @test_suite.test_cases.each { |test_case| errors.merge!(test_case.errors) }
            return
          end
        end
      else
        errors.add(:base, 'Llm Chat Query did not have python3 code to generate the inputs, and did not specify it has no inputs.')
        false
      end
    end

    def handle_python3_unit_tests; end

    def handle_c_unit_tests; end

    def handle_c_unit_tests_matching
      testing_code = @llm_chat_query.c_code
      if testing_code
        parser = CTestParser.new(testing_code)
        c_tests = parser.tests + parser.random_tests
        puts "All C Tests", c_tests

        c_tests.each do |c_test|
          single_test_code = parser.single_test_code(c_test)
          runner = CodeExecution::StandardCIORunner.new(single_test_code, [{ 'input': ''}], { 'solution.c' => @problem.reference_solution })
          test_cases = runner.generate_test_outputs
          test_case = test_cases[0]
          test_case.input = c_test
          puts "Test case now:", test_case
          if test_case.has_error?
            puts test_case
            puts test_case.error
            if @please_create
              @test_suite.test_cases.create(
                test: test_case.input, reference_solution_errors: test_case.error,
                rejected: true
              )
            end
          else
            puts "Output", test_case.output
            if @please_create
              @test_suite.test_cases.build(test: c_test, expected_output: test_case.output)
            end
          end
        end

        if @please_create
          unless @test_suite.save
            errors.merge!(@test_suite.errors)
            @test_suite.test_cases.each { |test_case| errors.merge!(test_case.errors) }
            return
          end
        end
      else
        errors.add(:base, 'Llm Chat Query did not have C code that tests the solution.')
        false
      end
    end

    def write_file(filename, data_to_write)
      file = File.new(filename, 'w')
      file.write(data_to_write)
      file.close
    end

    def read_file(filename)
      %x( cd tmp/services && cat #{filename} )
    end

    def run_python3(script_name)
      %x( cd tmp/services && python3 #{script_name} 1>run_python3.txt 2>run_python3_errors.txt )
    end
  end
end