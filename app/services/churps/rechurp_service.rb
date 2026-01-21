# frozen_string_literal: true

module Churps
  # Creates a rechurp (repost) for an existing churp.
  #
  # Responsibilities:
  # - Build a {Rechurp} record linking the user to the original churp
  # - Persist the rechurp or fail with errors
  #
  # @example
  #   Churps::RechurpService.call(user: current_user, original_churp: churp)
  class RechurpService < ApplicationService
    # @return [User] user reposting the churp
    # @return [Churp] original churp being reposted
    attr_reader :user, :original_churp

    # @param user [User] user creating the rechurp
    # @param original_churp [Churp] churp being rechurped
    def initialize(user:, original_churp:)
      @user = user
      @original_churp = original_churp
    end

    # Creates and persists the rechurp.
    #
    # @return [Rechurp]
    def execute!
      rechurp = Rechurp.new(
        user: user,
        original_churp: original_churp
      )

      return rechurp if rechurp.save!

      fail!(rechurp.errors.full_messages)
    rescue => e
      log_error("[RechurpService] #{e.class}: #{e.message}")
      fail!("Failed to rechurp")
    end
  end
end
