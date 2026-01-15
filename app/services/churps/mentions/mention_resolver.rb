# frozen_string_literal: true

module Churps
  class MentionResolver
    def self.call(usernames)
      User.where(username: usernames).pluck(:id)
    end
  end
end
