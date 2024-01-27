require "active_support/concern"

module ProgrammingLanguages
  extend ActiveSupport::Concern

  PROGRAMMING_LANGUAGES = [
    PROGRAMMING_LANGUAGE_C = 'c'.freeze,
    PROGRAMMING_LANGUAGE_PYTHON3 = 'python3'.freeze
  ]

  included do
  end

  class_methods do
  end
end
