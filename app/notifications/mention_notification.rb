# frozen_string_literal: true

class MentionNotification < Noticed::Base
  deliver_by :database
  deliver_by :action_cable, channel: "NotificationsChannel"

  param :churp_id
  param :start_index
  param :end_index

  def message
    "You were mentioned in a churp"
  end

  def url
    Rails.application.routes.url_helpers.churp_path(params[:churp_id])
  end
end
