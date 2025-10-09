# frozen_string_literal: true

module Seed
  class FollowSeeder
    attr_reader :users, :created_count, :skipped_count

    def initialize
      @users = User.all.to_a
      @created_count = 0
      @skipped_count = 0
    end

    def call
      return { created_count: 0, skipped_count: 0 } if users.size < 2

      users.each do |user|
        follow_random_users(user)
      end

      { created_count:, skipped_count: }
    rescue => e
      Rails.logger.error "[Seed::FollowSeeder] Error: #{e.message}"
      { created_count:, skipped_count:, error: e.message }
    end

    private

    def follow_random_users(user)
      potential_follows = users.sample(rand(3..10)).reject { |u| u == user }

      potential_follows.each do |target|
        next if user.following?(target)

        user.follow(target)
        @created_count += 1
      rescue => e
        @skipped_count += 1
        Rails.logger.error "[Seed::FollowSeeder] Failed follow (#{user.id} -> #{target.id}): #{e.message}"
      end
    end
  end
end
