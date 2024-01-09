class LlmQueriesController < ApplicationController
  before_action :set_llm_query, only: :show

  # GET /llm_queries or /llm_queries.json
  def index
    @llm_queries = LlmQuery.all
  end

  # GET /llm_queries/1 or /llm_queries/1.json
  def show
  end

  # GET /llm_queries/new
  def new
  end

  # POST /llm_queries or /llm_queries.json
  def create
    fake_matching_outputs_create_response # TODO: Remove
    return

    problem_description_service = LlmQueryServices::DetailedProblemDescriptionService.new(
      llm_query_params[:problem_statement],
      llm_query_params[:reference_solution]
    )

    tokens = [0, 0]
    if problem_description_service.run
      @llm_query = problem_description_service.data[:llm_query]
      tokens[0] +=  @llm_query.input_tokens
      tokens[1] += @llm_query.output_tokens
      case llm_query_params[:query_type]
      when 'matching_outputs'
        service = LlmQueryServices::MatchingOutputsService.new(
          llm_query_params[:problem_statement],
          @llm_query.query_json,
          llm_query_params[:reference_solution]
        )
      when 'unit_tests'
        service = LlmQueryServices::UnitTestsService.new(
          llm_query_params[:problem_statement],
          @llm_query.query_json,
          llm_query_params[:reference_solution]
        )
      else
        service = nil
      end

      if service
        if service.run
          @llm_query = service.data[:llm_query]
          tokens[0] +=  @llm_query.input_tokens
          tokens[1] += @llm_query.output_tokens

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
    def set_llm_query
      @llm_query = LlmQuery.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def llm_query_params
      params.require(:llm_query).permit(:problem_statement, :reference_solution, :query_type)
    end

    def fake_matching_outputs_create_response
      @llm_query = LlmQuery.find_by(query_type: LlmQuery::QUERY_TYPE_MATCHING_OUTPUTS)

      render json: { data: { message: @llm_query.query_pretty_json, llm_query: @llm_query, tokens: [@llm_query.input_tokens, @llm_query.output_tokens] } }
    end

    def fake_unit_tests_create_response
      @llm_query = LlmQuery.find_by(query_type: LlmQuery::QUERY_TYPE_UNIT_TESTS)

      render json: { data: { message: @llm_query.response, code: @llm_query.code&.to_s, llm_query: @llm_query, tokens: [@llm_query.input_tokens, @llm_query.output_tokens] } }
    end
end
