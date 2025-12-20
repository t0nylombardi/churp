# frozen_string_literal: true

module Churps
  class BroadcastService < ApplicationService
    attr_reader :churp

    def initialize(churp:)
      @churp = churp
    end

    def execute!
      ActionCable.server.broadcast("churps_channel", rendered_churp)
      @result = :ok
    rescue => e
      log_error("[BroadcastService] Failed to broadcast churp #{churp.id}: #{e.message}")
      fail!
    end

    private

    def rendered_churp
      ApplicationController.renderer.render(
        partial: "churps/churp",
        locals: { churp: }
      )
    end
  end
end
