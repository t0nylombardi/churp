# frozen_string_literal: true

class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    return unless current_user

    current_user.notifications.mark_as_read!
    @notifications = current_user.notifications.reverse
  end
end
