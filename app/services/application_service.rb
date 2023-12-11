class ApplicationService
  include ActiveModel::Validations

  def initialize; end
  def perform; end

  def run
    perform

    errors.empty?
  end

  attr_reader :data
end