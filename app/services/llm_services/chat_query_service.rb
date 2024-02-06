module LlmServices
  class ChatQueryService < ::ApplicationService
    def initialize(*args)
      super(args)
      @system_templates = YAML.load_file(File.join(__dir__, 'llm_chat_query_templates', 'system_prompts.yml'))
      @user_templates = YAML.load_file(File.join(__dir__, 'llm_chat_query_templates', 'user_prompts.yml'))
    end

    protected

    def get_system_template(template_name, *args)
      get_template('system', template_name, *args)
    end

    def get_user_template(template_name, *args)
      get_template('user', template_name, *args)
    end

    def new_query_log(query_type)
      @llm_chat_query = LlmChatQuery.new(
        problem_statement: @problem.statement,
        reference_solution: @problem.reference_solution,
        programming_language: @problem.programming_language,
        ai_model: Rails.application.credentials.dig(:openai, :model),
        temperature: Rails.application.credentials.dig(:openai, :temperature),
        query_type: query_type,
        problem_id: @problem.id
      )
    end

    def add_messages(messages)
      messages.each do |message|
        @llm_chat_query.llm_query_messages.build(message)
      end
    end

    def save_query_log
      return true if @llm_chat_query.save

      errors.merge!(@llm_chat_query.errors)
      @llm_chat_query.llm_query_messages.each { |llm_query_message| errors.merge!(llm_query_message.errors) }
      false
    end

    def add_query_response_fields(finish_reason, response, input_tokens, output_tokens)
      @llm_chat_query.finish_reason = finish_reason
      @llm_chat_query.response = response
      @llm_chat_query.input_tokens = input_tokens
      @llm_chat_query.output_tokens = output_tokens

      @llm_chat_query.completed_response = true if @llm_chat_query.finish_reason == 'stop'
    end

    private

    def get_template(role, template_name, *args)
      template = nil

      if role == 'system'
        template = @system_templates[template_name]
      elsif role == 'user'
        template = @user_templates[template_name]
      end

      return nil unless template

      sub_hash = {}
      # replace {{1}} with the first arg, {{2}} with the second, and so on
      args.each_with_index do |arg, index|
        sub_hash["{{#{index + 1}}}"] = arg
      end

      regex = /{{\d+}}/
      template.gsub(regex, sub_hash)
    end
  end
end