# frozen_string_literal: true

module Churps
  module Mentions
    class NotifierService < ApplicationService
      attr_reader :churp, :username

      def initialize(churp:, username:)
        @churp = churp
        @username = username
      end

      ##
      # Sends a mention notification to the specified user.
      #
      # @return [void]
      def execute!
        user = User.friendly.find(username)
        MentionNotifier.with(message: churp).deliver(user)
      rescue ActiveRecord::RecordNotFound
        log_error("[NotifierService] Mentioned user not found: #{username}")
      rescue => e
        log_error("\n\n[NotifierService] #{e.class}: #{e.message}\n\n")
        fail!
      end
    end
  end
end
