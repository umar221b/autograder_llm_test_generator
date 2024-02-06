module ProblemsHelper
  def test_type(query)
    case query.test_type
    when LlmChatQuery::QUERY_TYPE_DETAILED_PROBLEM_STATEMENT
      'success'
    when LlmChatQuery::QUERY_TYPE_MATCHING_OUTPUTS
      'warning'
    when LlmChatQuery::QUERY_TYPE_UNIT_TESTS
      'primary'
    else
      'info'
    end
  end

  def query_response(query)
    case query.query_type
    when LlmChatQuery::QUERY_TYPE_DETAILED_PROBLEM_STATEMENT
      query.query_pretty_json
    else
      query.response
    end
  end
end
