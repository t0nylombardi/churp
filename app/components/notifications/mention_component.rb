# frozen_string_literal: true

class Notifications::MentionComponent < ViewComponent::Base
  attr_reader :user, :churp, :unread, :read_at

  def initialize(user:, churp:, unread:, read_at: nil)
    super
    @user = user
    @churp = churp
    @unread = unread
    @read_at = read_at
  end

  def new_notification?
    read_at.nil? || read_at < 1.minute.ago
  end
end
