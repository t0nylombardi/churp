# frozen_string_literal: true

# To deliver this notification:
#
# MentionNotification.with(post: @post).deliver_later(current_user)
# MentionNotification.with(post: @post).deliver(current_user)

class MentionNotification < Noticed::Base
  deliver_by :database
  deliver_by :action_cable
  # Add your delivery methods
  #
  # deliver_by :database
  # deliver_by :email, mailer: "UserMailer"
  # deliver_by :slack
  # deliver_by :custom, class: "MyDeliveryMethod"

  # Define helper methods to make rendering easier.
  #
  def churp
    params[:message]
  end

  def creator
    churp.user
  end

  def mention
    churp.content
  end

  def url
    churp_path(params[:churp])
  end
end
