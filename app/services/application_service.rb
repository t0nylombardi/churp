# frozen_string_literal: true

class ApplicationService
  class Failure < StandardError; end

  class ServiceFailed < StandardError
    def initialize(msg = nil)
      super
    end
  end

  include ActiveModel::Validations

  attr_reader :result, :success
  alias_method :success?, :success

  # Class method to create an instance of the service and call its `call` method.
  #
  # @param args [Array] Arguments passed to the service's initializer.
  # @return [Utils::Result] The result of the service call.
  def self.call(*, &)
    new(*, &).call
  end

  # Class method to create an instance of the service, call its `call` method, and raise an exception if the service fails.
  #
  # @param args [Array] Arguments passed to the service's initializer.
  # @return [Utils::Result] The result of the service call if successful.
  # @raise [ServiceFailed] If the service encounters errors.
  def self.call!(**args)
    response = new(**args).call
    if response.success?
      response
    else
      error_message = Array(response.error).join(", ")
      raise ServiceFailed, error_message
    end
  end

  def call
    if errors.empty? && valid?
      @result = execute!
      @success = errors.none?
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
