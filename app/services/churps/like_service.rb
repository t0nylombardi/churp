# frozen_string_literal: true

module Churps
  # Registers a like from a user on a churp.
  #
  # Responsibilities:
  # - Create the Like record if it does not already exist
  # - Return :ok on success
  #
  # @example
  #   Churps::LikeService.call(user: current_user, churp: churp)
  class LikeService < ApplicationService
    # @return [User] user performing the like
    # @return [Churp] churp being liked
    attr_reader :user, :churp

    # @param user [User] user who likes the churp
    # @param churp [Churp] churp to be liked
    def initialize(user:, churp:)
      @user = user
      @churp = churp
    end

    # Creates the like, if missing.
    #
    # @return [void]
    def execute!
      user.likes.find_or_create_by!(likeable: churp)
      @result = :ok
    rescue => e
      log_error("[LikeService] Failed to like churp #{churp.id}: #{e.message}")
      fail!
    end
  end
end
