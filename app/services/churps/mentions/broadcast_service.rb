# frozen_string_literal: true

module Churps
  module Mentions
    class BroadcastService < ApplicationService
      attr_reader :username

      def initialize(username:)
        @username = username
      end

      ##
      # Broadcasts updated unread notification count to the mentioned user.
      #
      # @return [void]
      def execute!
        user = User.friendly.find(username)
        Turbo::StreamsChannel.broadcast_update_later_to(
          "notifications_count_#{user.id}",
          target: "notifications_count_#{user.id}",
          partial: "mentions/notification_count",
          locals: { user:, count: user.unread_notifications.count }
        )
      rescue ActiveRecord::RecordNotFound
        log_error("[BroadcastService] Could not find user for broadcast: #{username}")
      rescue => e
        log_error("[BroadcastService] #{e.class}: #{e.message}")
        fail!
      end
    end
  end
end
