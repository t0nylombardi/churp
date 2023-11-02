# frozen_string_literal: true

namespace :seed do
  # Populates follows.
  #   Api `rails 'seed:create_followers'`
  desc 'seed n amount of follows based off number of Users'
  task create_follows: :environment do
    users = User.all
    user  = users.first
    following = users[2..User.count]
    followers = users[3..User.count - 10]
    following.each { |followed| user.follow(followed) }
    followers.each { |follower| follower.follow(user) }
  end
end
