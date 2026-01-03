# frozen_string_literal: true

module Authentication
  module Commands
    class RegisterUser < ::Domain::Orchestrator
      def initialize(email:, password:)
        @email = email
        @password = password
      end

      def execute
        user = User.new(email: email, password_digest: Passwords::Hasher.hash(password))
        user.save ? success(user) : failure(:registration_failed)
      end
    end
  end
end
