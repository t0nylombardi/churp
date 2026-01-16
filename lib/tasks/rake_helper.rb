# frozen_string_literal: true

module RakeHelper
  def self.run(label:)
    result = yield

    case result
    in Dry::Monads::Success(value)
      Rails.logger.info "✅ #{label} succeeded"
      value
    in Dry::Monads::Failure(error)
      Rails.logger.error "❌ #{label} failed: #{error.message}"
      raise StandardError, "#{label} failed: #{error.message}"
    end
  end
end
