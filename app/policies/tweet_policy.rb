class TweetPolicy < ApplicationPolicy
  attr_reader :current_user, :tweet

  def initialize(current_user, tweet)
    super
    @current_user = current_user
    @tweet = tweet
  end

  def create?
    # current_user.admin?
  end

  def index?
    # current_user.admin?
  end

  def show?
    current_user.admin? || current_user.tweets.exists?(id: tweet.id)
  end

  def update?
    current_user.admin?
  end

  def destroy?
    current_user.admin?
  end
end