# frozen_string_literal: true

module Churps
  # Broadcasts a rendered churp partial to the public ActionCable channel.
  #
  # Responsibilities:
  # - Render the churp partial with the current churp instance
  # - Broadcast the HTML payload to the "churps_channel"
  # - Report failures through ApplicationService error flow
  #
  # This service intentionally does not persist any data. It focuses only on
  # delivery to clients already connected to the stream.
  #
  # @example
  #   Churps::BroadcastService.call(churp: churp)
  class BroadcastService < ApplicationService
    # @return [Churp] the churp being broadcast
    attr_reader :churp

    # @param churp [Churp] churp to render and broadcast
    def initialize(churp:)
      @churp = churp
    end

    # Broadcasts the rendered churp to ActionCable.
    #
    # @return [void]
    def execute!
      ActionCable.server.broadcast("churps_channel", rendered_churp)
      @result = :ok
    rescue => e
      log_error("[BroadcastService] Failed to broadcast churp #{churp.id}: #{e.message}")
      fail!
    end

    private

    # Renders the churp partial for broadcast payload.
    #
    # @return [String] rendered HTML fragment
    def rendered_churp
      ApplicationController.renderer.render(
        partial: "churps/churp",
        locals: { churp: }
      )
    end
  end
end
