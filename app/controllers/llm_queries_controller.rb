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
    @llm_query = LlmQuery.new
  end

  # POST /llm_queries or /llm_queries.json
  def create
    problem_description_service = DetailedProblemDescriptionService.new(
      llm_query_params[:problem_statement],
      llm_query_params[:instructor_solution]
    )

    tokens = [0, 0]
    if problem_description_service.run
      @llm_query = problem_description_service.data[:llm_query]
      tokens[0] +=  @llm_query.input_tokens
      tokens[1] += @llm_query.output_tokens
      case llm_query_params[:query_type]
      when 'matching_outputs'
        service = MatchingOutputsService.new(
          llm_query_params[:problem_statement],
          @llm_query.query_json,
          llm_query_params[:instructor_solution]
        )
      when 'unit_tests'
        service = UnitTestsService.new(
          llm_query_params[:problem_statement],
          @llm_query.query_json,
          llm_query_params[:instructor_solution]
        )
      else
        service = nil
      end

      if service
        if service.run
          tokens[0] +=  service.data[:llm_query].input_tokens
          tokens[1] += service.data[:llm_query].output_tokens

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
      params.require(:llm_query).permit(:problem_statement, :instructor_solution, :query_type)
    end
end
