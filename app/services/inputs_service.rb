require 'json'

class InputsService < LlmQueryService
  def initialize(detailed_problem_statement, instructor_code)
    super
    @problem_statement = JSON.parse(detailed_problem_statement)
    @instructor_code = instructor_code
    @client = OpenAI::Client.new
  end

  def perform
    new_query_log

    system_query = get_system_template('inputs')
    user_query = get_user_template('inputs',
                                   @problem_statement["scenario"],
                                   @problem_statement["inputs"],
                                   @problem_statement["outputs"],
                                   @problem_statement["example"],
                                   @problem_statement["limits"],
                                   @instructor_code
    )

    input_token_count = OpenAI.rough_token_count(system_query)
    input_token_count += OpenAI.rough_token_count(user_query)

    messages = [
      { role: "system", content: system_query },
      { role: "user", content: user_query }
    ]

    add_query_request_fields(input_token_count, messages)
    return unless save_query_log

    response = @client.chat(
      parameters: {
        model: Rails.application.credentials.dig(:openai, :model),
        response_format: { type: "json_object" },
        messages: messages,
        temperature: Rails.application.credentials.dig(:openai, :temperature),
      })

    # response = fake_response

    finish_reason = response.dig("choices", 0, "finish_reason")
    content = response.dig("choices", 0, "message", "content")
    output_token_count = content ? OpenAI.rough_token_count(content) : 0

    add_query_response_fields(finish_reason, content, output_token_count)
    return unless save_query_log

    @data = { message: content, llm_query: @llm_query }
  end

  private

  def fake_response
    content = [{ "input": "" }, { "input": "xyz" }, { "input": "xyzabc" }, { "input": "abcxyz" }, { "input": ".xyz" }, { "input": "abcxyzabc" }, { "input": "abcxyzxyzabc" }, { "input": "abc.xyzabcxyz" }, { "input": "...." }, { "input": "abcdefghijklmnopqrstuvw" }, { "input": "xkoenkdhxqkbiqjf." }, { "input": "hqlmvuku" }, { "input": "eeguug" }, { "input": "j" }, { "input": "kzwduyw" }, { "input": "olpfotendycoov" }, { "input": "ji.jfeeheyxq.jbplmjp" }, { "input": "vhewleopr" }, { "input": "ivbqyfctbrxkarr" }, { "input": "abmwpkhkl" }, { "input": "tkffymmmvdvzc" }, { "input": "ypbsmssba" }, { "input": "mopiqnqveqknvcibd" }, { "input": "bzwsxta." }, { "input": "uy" }, { "input": "trnjqnzi" }, { "input": "xkdpjdawlgsksakuyh" }, { "input": "gc.tihqatczasivpgtlx" }, { "input": "jtqiqusc" }, { "input": "ebiwgytiazfnt" }]
    response = { choices: [{ finish_reason: "stop", message: { content: JSON.dump(content) } }] }
    response.with_indifferent_access
  end
end