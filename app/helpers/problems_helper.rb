module ProblemsHelper
  def test_type(query)
    case query.test_type
    when LlmChatQuery::QUERY_TYPE_DETAILED_PROBLEM_STATEMENT
      'success'
    when LlmChatQuery::QUERY_TYPE_MATCHING_OUTPUTS
      'warning'
    when LlmChatQuery::QUERY_TYPE_PYTHON3_UNIT_TESTS, LlmChatQuery::QUERY_TYPE_C_UNIT_TESTS
      'primary'
    else
      'info'
    end
  end

  def query_response(query)
    case query.test_type
    when LlmChatQuery::QUERY_TYPE_DETAILED_PROBLEM_STATEMENT
      query.query_pretty_json
    when LlmChatQuery::QUERY_TYPE_MATCHING_OUTPUTS
      query.query_pretty_json
    when LlmChatQuery::QUERY_TYPE_PYTHON3_UNIT_TESTS, LlmChatQuery::QUERY_TYPE_C_UNIT_TESTS
      query.response
    else
      query.response
    end
  end
end
