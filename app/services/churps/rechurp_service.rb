# frozen_string_literal: true

module Churps
  class RechurpService < ApplicationService
    attr_reader :user, :original_churp

    def initialize(user:, original_churp:)
      @user = user
      @original_churp = original_churp
    end

    def execute!
      rechurp = user.churps.new(
        body: original_churp.body.to_plain_text,
        churp_id: original_churp.id
      )

      if rechurp.save
        original_churp.increment!(:rechurp_count)
        @result = rechurp
      else
        fail!
      end
    rescue => e
      log_error("[RechurpService] #{e.class}: #{e.message}")
      fail!
    end
  end
end
