# frozen_string_literal: true

class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    return unless current_user

    @notifications = current_user.notifications.sort.reverse
    current_user.notifications.mark_as_read!
  end
end
