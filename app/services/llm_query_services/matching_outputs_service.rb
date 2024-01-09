require 'json'

module LlmQueryServices
  class MatchingOutputsService < QueryService
    def initialize(problem_statement, detailed_problem_statement, reference_solution)
      super
      @problem_statement = problem_statement
      @detailed_problem_statement = detailed_problem_statement
      @reference_solution = reference_solution
      @client = OpenAI::Client.new
    end

    def perform
      new_query_log(LlmQuery::QUERY_TYPE_MATCHING_OUTPUTS)

      system_query = get_system_template(LlmQuery::QUERY_TYPE_MATCHING_OUTPUTS)
      user_query = get_user_template(LlmQuery::QUERY_TYPE_MATCHING_OUTPUTS,
                                     @detailed_problem_statement["scenario"],
                                     @detailed_problem_statement["inputs"],
                                     @detailed_problem_statement["outputs"],
                                     @detailed_problem_statement["example"],
                                     @detailed_problem_statement["limits"],
                                     @reference_solution
      )

      input_token_count = OpenAI.rough_token_count(system_query)
      input_token_count += OpenAI.rough_token_count(user_query)

      messages = [
        { role: "system", content: system_query },
        { role: "user", content: user_query }
      ]

      add_query_request_fields(input_token_count, messages)
      return unless save_query_log

      # response = @client.chat(
      #   parameters: {
      #     model: Rails.application.credentials.dig(:openai, :model),
      #     response_format: { type: "json_object" },
      #     messages: messages,
      #     temperature: Rails.application.credentials.dig(:openai, :temperature),
      #   })

      response = fake_response # TODO: Remove

      finish_reason = response.dig("choices", 0, "finish_reason")
      content = response.dig("choices", 0, "message", "content")
      output_token_count = content ? OpenAI.rough_token_count(content) : 0

      add_query_response_fields(finish_reason, content, output_token_count)
      return unless save_query_log

      @data = { message: @llm_query.query_pretty_json, llm_query: @llm_query }
    end

    private

    def fake_response
      content = [{ "input": "0" }, { "input": "2147483647" }, { "input": "129" }, { "input": "128" }, { "input": "2147483646" }, { "input": "1187304912" }, { "input": "599940036" }, { "input": "345657264" }, { "input": "561982046" }, { "input": "908112212" }, { "input": "1220308420" }, { "input": "2044496724" }, { "input": "857239504" }, { "input": "1672477189" }, { "input": "1085355198" }, { "input": "642345686" }, { "input": "1200063633" }, { "input": "930008544" }, { "input": "1224041174" }, { "input": "515617281" }, { "input": "395107018" }, { "input": "795064" }, { "input": "1973544702" }, { "input": "450947684" }, { "input": "1788674158" }]
      response = { choices: [{ finish_reason: "stop", message: { content: JSON.dump(content) } }] }
      response.with_indifferent_access
    end
  end
end