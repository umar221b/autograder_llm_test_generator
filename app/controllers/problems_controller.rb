class ProblemsController < ApplicationController
  before_action :set_problem, only: :show

  # GET /problems or /problems.json
  def index
    @problem = Problem.all
  end

  # GET /problems/1 or /problems/1.json
  def show
  end

  # GET /problems/new
  def new
  end

  # POST /problems or /problems.json
  def create
    # fake_matching_outputs_create_response # TODO: Remove
    # return

    problem_description_service = LlmServices::GenerateDetailedProblemDescriptionService.new(
      llm_query_params[:problem_statement],
      llm_query_params[:reference_solution],
      llm_query_params[:programming_language]
    )

    test_type = LlmChatQuery::QUERY_TYPE_MATCHING_OUTPUTS
    if llm_query_params[:test_type] == 'unit_tests'
      if llm_query_params[:test_type] == LlmChatQuery::PROGRAMMING_LANGUAGE_C
        test_type = LlmChatQuery::QUERY_TYPE_C_UNIT_TESTS
      elsif llm_query_params[:test_type] == LlmChatQuery::PROGRAMMING_LANGUAGE_PYTHON3
        test_type = LlmChatQuery::QUERY_TYPE_PYTHON3_UNIT_TESTS
      end
    end

    tokens = [0, 0]
    if problem_description_service.run
      @llm_chat_query = problem_description_service.data[:llm_chat_query]
      tokens[0] +=  @llm_chat_query.input_tokens
      tokens[1] += @llm_chat_query.output_tokens
      case test_type
      when LlmChatQuery::QUERY_TYPE_MATCHING_OUTPUTS
        service = LlmServices::GenerateMatchingOutputsService.new(
          llm_query_params[:problem_statement],
          @llm_chat_query.query_json,
          llm_query_params[:reference_solution],
          llm_query_params[:programming_language]
        )
      when LlmChatQuery::QUERY_TYPE_PYTHON3_UNIT_TESTS
        service = LlmServices::GeneratePythonUnitTestsService.new(
          llm_query_params[:problem_statement],
          @llm_chat_query.query_json,
          llm_query_params[:reference_solution],
          llm_query_params[:programming_language]
        )
      else
        service = nil
      end

      if service
        if service.run
          @llm_chat_query = service.data[:llm_chat_query]
          tokens[0] +=  @llm_chat_query.input_tokens
          tokens[1] += @llm_chat_query.output_tokens

          render json: { data: { **service.data, tokens: tokens } }
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
      params.require(:problem).permit(:statement, :reference_solution, :programming_language, :test_type)
    end

    def fake_matching_outputs_create_response
      @problem = Problem.find_by(test_type: Problem::TEST_TYPE_MATCHING_OUTPUTS)

      render json: { data: { problem: @problem, llm_chat_queries: @problem.llm_chat_queries } }
    end

    def fake_python3_unit_tests_create_response
      @problem = Problem.find_by(test_type: Problem::TEST_TYPE_PYTHON3_UNIT_TESTS)

      render json: { data: { problem: @problem, llm_chat_queries: @problem.llm_chat_queries } }
    end
end
