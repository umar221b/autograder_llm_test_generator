module ProblemsHelper
  def test_type(query)
    case query.test_type
    when LlmChatQuery::QUERY_TEMPLATE_DETAILED_PROBLEM_STATEMENT
      'success'
    when LlmChatQuery::QUERY_TEMPLATE_MATCHING_OUTPUTS
      'warning'
    when LlmChatQuery::QUERY_TEMPLATE_PYTHON3_UNIT_TESTS
      'primary'
    else
      'info'
    end
  end

  def query_response(query)
    case query.query_template
    when LlmChatQuery::QUERY_TEMPLATE_DETAILED_PROBLEM_STATEMENT
      query.query_pretty_json
    else
      query.response
    end
  end
end
