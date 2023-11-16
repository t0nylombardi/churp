class ApplicationService
  class Failure < StandardError; end

  class ServiceFailed < StandardError
    def initialize(msg = nil)
      super
    end
  end

  include ActiveModel::Validations

  attr_reader :result, :success
  alias success? success

  def self.call(...)
    new(...).call
  end

  def self.call!(...)
    response = new(...).call
    response if response.success?

    raise ServiceFailed, response.errors.full_messages.to_sentence unless response.success?
  end

  def call
    if errors.empty? && valid?
      @result = execute!
      @success = errors.any? ? false : true
    else
      @success = false
    end

    self
  rescue Failure
    self
  end

  private

  def execute!
    raise NotImplementedError
  end

  def fail!
    @success = false
    raise Failure
  end

  def log_error(message)
    Rails.logger.error(message)
  end

  def map_errors(result_error_object:, current_error:)
    current_error.each_key do |error_key|
      result_error_object.add(error_key, current_error[error_key].to_sentence)
    end
    result_error_object
  end
end
