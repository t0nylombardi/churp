# frozen_string_literal: true

module Authentication
  module Commands
    class LoginUser
      def self.call(email:, password:)
        user = User.find_by(email: email)
        return nil unless user

        valid = Passwords::Verifier.verify(
          password,
          user.password_digest
        )

        return nil unless valid

        Tokens::JwtEncoder.encode({user_id: user.id})
      end
    end
  end
end
