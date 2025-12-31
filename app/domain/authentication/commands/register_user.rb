# frozen_string_literal: true

module Authentication
  module Commands
    class RegisterUser
      def self.call(email:, password:)
        User.create!(
          email: email,
          password_digest: Passwords::PasswordHasher.hash(password)
        )
      end
    end
  end
end
