# frozen_string_literal: true

class Notifications::MentionComponent < ViewComponent::Base
  def initialize(user:, churp:, unread:)
    @user = user
    @churp = churp
    @unread = unread
  end

end
