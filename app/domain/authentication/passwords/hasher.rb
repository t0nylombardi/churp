# frozen_string_literal: true

module Authentication
  module Passwords
    class Hasher
      def self.hash(password)
        BCrypt::Password.create(password)
      end
    end
  end
end
