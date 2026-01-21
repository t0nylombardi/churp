# frozen_string_literal: true

module Users
  module Types
    include Dry.Types()

    # Raw username input (may include @, dots, hyphens, etc)
    RawUsername = Types::String.optional

    # Email local part (before @)
    EmailLocalPart = Types::String.constrained(format: /^[a-zA-Z0-9._-]+$/)

    # Normalized username body (no @)
    UsernameBody =
      Types::String
        .constructor(&:downcase)
        .constrained(format: /^@[a-z0-9_]{1,30}$/)

    # Final persisted username (includes @)
    Username =
      UsernameBody.constructor { |v| "@#{v}" }
  end
end
