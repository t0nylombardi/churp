# frozen_string_literal: true

module Authentication
  module Passwords
    class PasswordVerifier
      def self.verify(password, digest)
        BCrypt::Password.new(digest) == password
      end
    end
  end
end
