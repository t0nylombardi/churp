# frozen_string_literal: true

module Churps
  module Mentions
    class Resolver
      def self.call(mentions)
        usernames = extract_usernames(mentions)
        fetch_users(usernames)
      end

      private_class_method def self.extract_usernames(mentions)
        mentions.map(&:username).uniq
      end

      private_class_method def self.fetch_users(usernames)
        User
          .where(username: usernames)
          .pluck(:username, :id)
          .to_h
      end
    end
  end
end
