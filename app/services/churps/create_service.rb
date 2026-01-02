# frozen_string_literal: true

# == Churps::CreateService
#
# Service object responsible for orchestrating the full creation lifecycle of a {Churp}.
# This includes:
#
# * Building and persisting a new {Churp} record for a given user.
# * Extracting and associating hashtags via {Churps::HashtagsService}.
# * Broadcasting the newly created churp over ActionCable using {Churps::BroadcastService}.
# * Sending mention notifications to users referenced within the churp via {Churps::NotificationsService}.
#
# The service centralizes all post-creation side effects that would otherwise
# live in model callbacks, following the Single Responsibility Principle (SRP)
# and keeping the `Churp` model lean and persistence-focused.
#
# === Usage
#
#   result = Churps::CreateService.call(user: current_user, params: churp_params)
#
#   if result.success?
#     puts "Churp created with ID: #{result.result.id}"
#   else
#     puts "Failed to create churp"
#   end
#
# === Error Handling
#
# Any raised exceptions or validation failures will:
# * Be logged via {ApplicationService#log_error}
# * Trigger a call to {ApplicationService#fail!}
# * Return a failed service response (`success? == false`)
#
# @see ApplicationService
# @see Churps::HashtagsService
# @see Churps::BroadcastService
# @see Churps::NotificationsService
#
module Churps
  class CreateService < ApplicationService
    # @return [User] the user creating the churp
    attr_reader :user

    # @return [ActionController::Parameters, Hash] the attributes for the churp
    attr_reader :params

    # @return [Churp] the churp instance created by this service
    attr_reader :churp

    # Initializes the service with a user and churp parameters.
    #
    # @param user [User] the author of the churp
    # @param params [ActionController::Parameters, Hash] permitted attributes for the churp
    #
    def initialize(user:, params:)
      @user = user
      @params = params
    end

    # Executes the churp creation workflow.
    #
    # Steps:
    # 1. Builds a new churp for the provided user.
    # 2. Attempts to save it.
    # 3. If successful, invokes secondary services to handle hashtags,
    #    broadcasting, and notifications.
    #
    # @return [void]
    #
    # @raise [ApplicationService::Failure] if validation or processing fails
    #
    def execute!
      @churp = user.churps.build(params)

      if churp.save
        process_hashtags
        broadcast_churp
        broadcast_notifications
        @result = churp
      else
        log_error("[CreateService] Validation failed: #{churp.errors.full_messages.join(", ")}")
        fail!
      end
    rescue => e
      log_error("[CreateService] #{e.class}: #{e.message}")
      fail!
    end

    private

    # Delegates hashtag extraction and association to {Churps::HashtagsService}.
    #
    # @return [void]
    def process_hashtags
      Churps::HashtagsService.call(churp:)
    end

    # Delegates broadcast rendering and publishing to {Churps::BroadcastService}.
    #
    # @return [void]
    def broadcast_churp
      Churps::BroadcastService.call(churp:)
    end

    # Delegates mention notification dispatch to {Churps::NotificationsService}.
    #
    # @return [void]
    def broadcast_notifications
      Churps::NotificationsService.call(churp:)
    end
  end
end
