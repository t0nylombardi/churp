# frozen_string_literal: true

module Followers
  class LinkBlockComponent < ViewComponent::Base
    def initialize(path:, name:)
      super
      @path = path
      @name = name
    end
  end
end
