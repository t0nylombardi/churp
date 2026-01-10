# frozen_string_literal: true

module Churps
  class RechurpService < ApplicationService
    attr_reader :user, :original_churp

    def initialize(user:, original_churp:)
      @user = user
      @original_churp = original_churp
    end

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
