OpenAI.configure do |config|
  config.access_token = Rails.application.credentials.dig(:openai, :api_key)
  config.organization_id = Rails.application.credentials.dig(:openai, :organization_id)
end