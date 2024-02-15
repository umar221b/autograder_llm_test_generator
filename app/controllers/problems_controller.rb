class ProblemsController < ApplicationController
  before_action :set_problem, only: :show

  # GET /problems or /problems.json
  def index
    @problems = Problem.includes(llm_chat_queries: :llm_query_messages)
  end

  # GET /problems/1 or /problems/1.json
  def show
  end

  # GET /problems/new
  def new
  end

  # POST /problems or /problems.json
  def create
    fake_matching_outputs_create_response # TODO: Remove
    return

    @problem = Problem.new(problem_params)

    unless @problem.save
      render json: { error: @problem.errors.full_messages.join(', and ') }, status: :bad_request
      return
    end

    problem_description_service = LlmServices::GenerateDetailedProblemDescriptionService.new(@problem)

    test_type = LlmChatQuery::QUERY_TEMPLATE_MATCHING_OUTPUTS
    if problem_params[:test_type] == 'unit_tests'
      if problem_params[:test_type] == LlmChatQuery::PROGRAMMING_LANGUAGE_C
        test_type = LlmChatQuery::QUERY_TYPE_C_UNIT_TESTS
      elsif problem_params[:test_type] == LlmChatQuery::PROGRAMMING_LANGUAGE_PYTHON3
        test_type = LlmChatQuery::QUERY_TYPE_PYTHON3_UNIT_TESTS
      end
    end

    tokens = [0, 0]
    if problem_description_service.run
      @llm_detailed_query = problem_description_service.data[:llm_chat_query]

      case test_type
      when Problem::TEST_TYPE_MATCHING_OUTPUTS
        service = LlmServices::GenerateMatchingOutputsService.new(@problem, @llm_detailed_query.query_json)
      when Problem::TEST_TYPE_PYTHON3_UNIT_TESTS
        service = LlmServices::GeneratePython3UnitTestsService.new(@problem, @llm_detailed_query.query_json)
      else
        service = nil
      end

      if service
        if service.run
          render json: { data: { **service.data } }
        else
          render json: { error: service.errors.full_messages.join(', and') }, status: :bad_request
        end
      else
        render json: { error: 'Invalid output type' }, status: :bad_request
      end
    else
      render json: { error: problem_description_service.errors.full_messages.join(', and ') }, status: :bad_request
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_problem
      @problem = Problem.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def problem_params
      params.require(:problem).permit(:title, :statement, :reference_solution, :extra_code, :programming_language, :test_type)
    end

    def fake_matching_outputs_create_response
      @problem = Problem.find_by(test_type: Problem::TEST_TYPE_MATCHING_OUTPUTS)

      render json: { data: { llm_chat_query: @problem.llm_chat_queries.where.not(query_template: LlmChatQuery::QUERY_TEMPLATE_DETAILED_PROBLEM_STATEMENT).last } }
    end

    def fake_python3_unit_tests_create_response
      @problem = Problem.find_by(test_type: Problem::TEST_TYPE_PYTHON3_UNIT_TESTS)

      render json: { data: { llm_chat_query: @problem.llm_chat_queries.where.not(query_template: LlmChatQuery::QUERY_TEMPLATE_DETAILED_PROBLEM_STATEMENT).last } }
    end
end
