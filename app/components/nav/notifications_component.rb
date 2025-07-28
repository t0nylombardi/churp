# frozen_string_literal: true

module Nav
  class NotificationsComponent < ViewComponent::Base
    def initialize(user:)
      super
      @user = user
      @unread = @user.unread_notifications
    end
  end
end
