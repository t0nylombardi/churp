# frozen_string_literal: true

require_relative "results/failure"

class Orchestrator
  attr_reader :result

  def self.call(**args)
    new(**args).call
  end

  def call
    @result = execute
  rescue => error
    failure(unexpected_error(error))
  end

  private

  def execute
    raise NotImplementedError, "Domain orchestrators must implement #execute"
  end

  def success(value = nil)
    Results::Success.new(value)
  end

  def failure(error)
    Rails.logger.info("\nOrchestrator failure: #{error}\n")
    Results::Failure.new(error)
  end

  def unexpected_error(error)
    Rails.logger.error("\nUnexpected error: #{error.message}\n#{error.backtrace.join("\n")}\n")
    :unexpected_error
  end
end
