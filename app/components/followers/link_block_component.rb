# frozen_string_literal: true

class Followers::LinkBlockComponent < ViewComponent::Base
  def initialize(path:, name:)
    super
    @path = path
    @name = name
  end
end
