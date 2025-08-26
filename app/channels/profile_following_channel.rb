# frozen_string_literal: true

class ProfileFollowingChannel < ApplicationCable::Channel
  def subscribed
    stream_from "profile_following_channel"
  end
end
