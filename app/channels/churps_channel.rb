# frozen_string_literal: true

class ChurpsChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'churps_channel'
    
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def receive(data)
    ActionCable.server.broadcast('churps_channel', data)
  end
end
