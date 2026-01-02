# frozen_string_literal: true

# To deliver this notification:
#
# MentionNotifier.with(record: @post, message: "New post").deliver(User.all)

class MentionNotifier < ApplicationNotifier
  deliver_by :action_cable do |config|
    config.channel = "ChurpsChannel"
    config.message = "You were mentioned in a churp"
  end

  required_param :message

  notification_methods do
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
end
