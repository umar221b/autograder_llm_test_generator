module LlmQueriesHelper
  def query_type(query)
    case query.query_type
    when LlmQuery::QUERY_TYPE_DETAILED_PROBLEM_STATEMENT
      'success'
    when LlmQuery::QUERY_TYPE_MATCHING_OUTPUTS
      'warning'
    when LlmQuery::QUERY_TYPE_UNIT_TESTS
      'primary'
    else
      'info'
    end
  end

  def query_response(query)
    case query.query_type
    when LlmQuery::QUERY_TYPE_DETAILED_PROBLEM_STATEMENT
      query.query_pretty_json
    when LlmQuery::QUERY_TYPE_MATCHING_OUTPUTS
      query.query_pretty_json
    when LlmQuery::QUERY_TYPE_UNIT_TESTS
      query.response
    else
      query.response
    end
  end
end
