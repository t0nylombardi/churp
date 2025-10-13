# frozen_string_literal: true

class ApplicationService
  class Failure < StandardError; end

  class ServiceFailed < StandardError; end

  include ActiveModel::Validations

  attr_reader :result, :success
  alias_method :success?, :success

  # Generic entrypoint for keyword-based initialization
  def self.call(**args, &block)
    new(**args, &block).call
  end

  def self.call!(**args)
    service = new(**args).call
    return service if service.success?

    error_message = service.error_message || "Service failed"
    raise ServiceFailed, error_message
  end

  def call
    @success = false

    if valid?
      value = execute!
      @result ||= value
      @success = true unless errors.any?
    end

    self
  rescue Failure
    @success = false
    self
  rescue => e
    log_error("[#{self.class.name}] #{e.class}: #{e.message}")
    @success = false
    self
  end

  private

  # Subclasses implement their main logic here
  def execute!
    raise NotImplementedError
  end

  # Mark service as failed
  def fail!(message = nil)
    log_error(message) if message
    @success = false
    raise Failure
  end

  def log_error(message)
    Rails.logger.error(message)
  end

  def error_message
    errors.full_messages.join(", ") if errors.any?
  end
end
