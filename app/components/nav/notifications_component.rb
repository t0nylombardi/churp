# frozen_string_literal: true

class Nav::NotificationsComponent < ViewComponent::Base

  def initialize(user:)
    super
    @user = user
    @unread = @user.unread_notifications
  end

end
