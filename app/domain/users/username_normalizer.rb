# frozen_string_literal: true

module Users
  class UsernameNormalizer
    include Dry::Monads[:result]

    INVALID_CHARS = /[^a-z0-9_]/

    def self.call(username:, email:)
      new(username:, email:).call
    end

    def initialize(username:, email:)
      @username = username
      @email = email
    end

    def call
      base = extract_base
      body = normalize(base)

      Success(Username.new(value: body))
    rescue Dry::Types::ConstraintError => e
      Failure(e)
    end

    private

    attr_reader :username, :email

    def extract_base
      return strip_at(username) if username.present?

      extract_from_email
    end

    def strip_at(value)
      value.delete_prefix("@")
    end

    def extract_from_email
      email.split("@").first
    end

    def normalize(value)
      value
        .downcase
        .tr(".-", "_")
        .gsub(INVALID_CHARS, "_")
        .squeeze("_")
        .delete_suffix("_")
    end
  end
end
