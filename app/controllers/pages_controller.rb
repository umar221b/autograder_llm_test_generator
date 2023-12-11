class PagesController < ApplicationController
  def home; end

  def submit
    problem_description_service = DetailedProblemDescriptionService.new(
                                    autograding_request_params[:problem_statement],
                                    autograding_request_params[:instructor_solution]
                                  )
    if problem_description_service.run
      case autograding_request_params[:output_type]
      when 'inputs'
        service = InputsService.new(
          problem_description_service.data[:message],
          autograding_request_params[:instructor_solution]
        )
      when 'unit_tests'
        service = UnitTestsService.new(
          problem_description_service.data[:message],
          autograding_request_params[:instructor_solution]
        )
      end

      if service
        if service.run
          tokens = problem_description_service.data[:tokens]
          tokens[0] += service.data[:tokens][0]
          tokens[1] += service.data[:tokens][1]

          render json: { data: { **service.data, tokens: tokens } }
        else
          render json: { error: service.errors.full_messages.join(', and') }, status: :bad_request
        end
      else
        render json: { error: 'Invalid output type' }, status: :bad_request
      end
    else
      render json: { error: problem_description_service.errors.full_messages.join(', and') }, status: :bad_request
    end
  end

  private

  def autograding_request_params
    params.require(:autograding_request).permit(:problem_statement, :instructor_solution, :output_type)
  end
end
