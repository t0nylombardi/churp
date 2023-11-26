# frozen_string_literal: true

class BroadcastNotificationsService < ApplicationService
  include Turbo::StreamsHelper
  include ActionView::RecordIdentifier
  include Twitter::TwitterText::Extractor

  attr_reader :churp

  def initialize(churp)
    @churp = churp
  end

  def execute!
    usernames = extract_usernames(text)
    return false unless usernames

    send_notifications(usernames)
  end

  private

  def extract_usernames(text)
    usernames = extract_mentioned_screen_names(text)
    usernames.detect { |username| usernames.count(username) > 1 }.split unless usernames.empty?
  end

  def send_notifications(usernames)
    usernames.each do |username|
      user = User.friendly.find(username)
      MentionNotification.with(message: churp).deliver_later(user)
      broadcast(user)
    end
  end

  def broadcast(user)
    count = user.unread_notifications.count
    Turbo::Streams::Broadcasts.broadcast_update_later_to "notifications_count_#{user.id}",
                                                         target: "notifications_count_#{user.id}",
                                                         partial: 'mentions/notification_count',
                                                         locals: { user:, count: }
  end

  def text
    churp.content.body.to_s
  end
end
