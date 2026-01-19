# frozen_string_literal: true

module Churps
  module Mentions
    # Resolves mentioned usernames to user ids.
    #
    # This resolver only fetches existing users and does not create records.
    class Resolver
      # Resolves usernames to user ids.
      #
      # @param mentions [Array<Churps::Mentions::Mention>]
      # @return [Hash{String=>Integer}] map of username to user id
      def self.call(mentions)
        usernames = mentions.map(&:username).uniq
        fetch_users(usernames)
      end

      private_class_method def self.fetch_users(usernames)
        # NOTE: Intentionally returns only existing users.
        User
          .where(username: usernames)
          .pluck(:username, :id)
          .to_h
      end
    end
  end
end
