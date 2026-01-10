# frozen_string_literal: true

# require_relative "../../domain/orchestrator"

module Authentication
  module Commands
    class LoginUser < Orchestrator
      def initialize(email:, password:)
        @email = email
        @password = password
      end

      def execute
        user = User.find_by(email: email)
        return failure(:invalid_credentials) unless user

        valid = Authentication::Passwords::Verifier.verify(password, user.password_digest)
        return failure(:invalid_credentials) unless valid

        success(Tokens::JwtEncoder.encode({user_id: user.id}))
      end

      private

      attr_reader :email, :password
    end
  end
end
