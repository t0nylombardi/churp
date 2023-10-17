# frozen_string_literal: true

class ViewChurpsChannel < ApplicationCable::Channel
  def subscribed
    # stream_from 'view_churps_channel'
    stream_from "view_#{params[:churp_id]}_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def churp_data
    churp = Churp.find(params[:churp_id])
    user = current_user
    view_count = View.by_user(user, churp).all.count
    churp = {
      user_id: current_user.id,
      churp_id: churp.id,
      view_count:
    }

    ActionCable.server.broadcast "view_#{params[:churp_id]}_channel", { churp: }
  end
end
