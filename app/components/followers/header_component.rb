# frozen_string_literal: true

module Followers
  class HeaderComponent < ViewComponent::Base
    def initialize(view: nil, followers: nil, following: nil)
      super
      @view = view
      @followers = followers
      @following = following
    end

    def render?
      @view || @followers || @following
    end
  end
end
