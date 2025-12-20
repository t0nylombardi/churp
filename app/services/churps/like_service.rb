# frozen_string_literal: true

module Churps
  class LikeService < ApplicationService
    attr_reader :user, :churp

    def initialize(user:, churp:)
      @user = user
      @churp = churp
    end

    def execute!
      user.likes.find_or_create_by!(likeable: churp)
      @result = :ok
    rescue => e
      log_error("[LikeService] Failed to like churp #{churp.id}: #{e.message}")
      fail!
    end
  end
end
