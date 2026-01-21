# frozen_string_literal: true

module Seed
  class FollowSeeder < BaseSeeder
    include Dry::Monads[:result, :do]

    def initialize
      @users = User.all.to_a
      @created_count = 0
      @skipped_count = 0
    end

    def call
      yield ensure_enough_users
      yield seed_follows

      success(created_count:, skipped_count:)
    rescue => e
      Rails.logger.error("[Seed::FollowSeeder] Fatal error: #{e.message}")
      failure(e)
    end

    private

    attr_reader :users, :created_count, :skipped_count

    def ensure_enough_users
      return success if users.size >= 2

      success # not a failure — nothing to do
    end

    def seed_follows
      users.each { |user| follow_random_users(user) }
      success
    end

    def follow_random_users(user)
      potential_targets(user).each do |target|
        create_follow(user, target)
      end
    end

    def create_follow(user, target)
      return skip unless followable?(user, target)

      user.follow(target)
      @created_count += 1
    rescue => e
      @skipped_count += 1
      Rails.logger.error(
        "[Seed::FollowSeeder] Failed follow (#{user.id} -> #{target.id}): #{e.message}"
      )
    end

    def potential_targets(user)
      users
        .sample(rand(3..10))
        .reject { |u| u == user }
    end

    def followable?(user, target)
      !user.following?(target)
    end

    def skip
      @skipped_count += 1
    end
  end
end
