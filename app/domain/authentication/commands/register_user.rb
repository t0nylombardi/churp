# frozen_string_literal: true

module Authentication
  module Commands
    class RegisterUser < Orchestrator
      def initialize(email:, password:)
        @email = email
        @password = password
      end

      def execute
        user = User.new(email: @email, password_digest: Passwords::Hasher.hash(@password))
        binding.pry
        user.save ? success(user) : failure(:registration_failed)
      end
    end
  end
end
