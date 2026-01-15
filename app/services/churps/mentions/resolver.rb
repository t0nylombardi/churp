module Churps
  module Mentions
    class Resolver
      def self.call(mentions)
        usernames = mentions.map(&:username)

        User
          .where(username: usernames)
          .pluck(:username, :id)
          .to_h
      end
    end
  end
end
