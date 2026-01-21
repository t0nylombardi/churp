# frozen_string_literal: true

module Authentication
  module Commands
    class RegisterUser < Orchestrator
      def initialize(username:, email:, password:)
        @username = username
        @email = email
        @password = password
      end

      def execute
        User.new(
          username: @username,
          email: @email,
          password: @password
        ).save!
        success(id: User.last.id)
      rescue ActiveRecord::RecordInvalid => e
        failure(error: e.record.errors.full_messages)
      end
    end
  end
end
