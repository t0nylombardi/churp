# frozen_string_literal: true

module Churps
  module Mentions
    class Policy
      def self.allowed?(author:, mentioned_user:, churp:)
        return false if author.id == mentioned_user.id
        return false if author.blocked?(mentioned_user)
        return false if mentioned_user.blocked?(author)
        return false if churp.private? && !churp.visible_to?(mentioned_user)

        true
      end
    end
  end
end
