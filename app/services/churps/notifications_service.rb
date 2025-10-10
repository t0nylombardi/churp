# frozen_string_literal: true

# == Churps::NotificationsService
#
# Orchestrates the complete notification process for mentions inside a churp.
#
# === Responsibilities
# * Delegates extraction of mentioned usernames to {Churps::Mentions::ExtractorService}
# * Delegates notification delivery to {Churps::Mentions::NotifierService}
# * Delegates broadcast updates to {Churps::Mentions::BroadcastService}
#
# === Example
#   result = Churps::NotificationsService.call(churp: churp)
#
#   if result.success?
#     puts "Notifications sent!"
#   else
#     puts "Something went wrong!"
#   end
#
# === Benefits
# * Keeps mention logic out of the model and controller layers
# * Each step (extraction, delivery, broadcast) is independently testable
# * Failures are logged and encapsulated in service error flow
module Churps
  class NotificationsService < ApplicationService
    attr_reader :churp

    def initialize(churp:)
      @churp = churp
    end

    ##
    # Executes the full mention notification workflow:
    # 1. Extract usernames mentioned in the churp
    # 2. Deliver mention notifications
    # 3. Broadcast updated unread counts
    #
    # @return [void]
    def execute!
      usernames = Churps::Mentions::ExtractorService.call(churp:)
      if usernames.blank?
        log_error("[NotificationsService] No mentions found in churp #{churp.id}")
        fail!
      end

      usernames.each do |username|
        Churps::Mentions::NotifierService.call(churp:, username:)
        Churps::Mentions::BroadcastService.call(username:)
      end

      @result = { status: :ok, message: "Notifications broadcasted successfully." }
    rescue => e
      log_error(format_error(e))
      fail!
    end

    private

    def format_error(error)
      "[NotificationsService] #{error.class}: #{error.message}\n#{error.backtrace&.first(3)&.join("\n")}"
    end
  end
end
