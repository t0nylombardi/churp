# frozen_string_literal: true

class ProfileComponents::Buttons::FollowComponent < ViewComponent::Base
  def initialize(user:, profile:)
    super
    @user = user
    @profile = profile
  end

  def render?
    @user != @profile.user
  end
end
