# frozen_string_literal: true

class TrendingTopicComponent < ViewComponent::Base
  def initialize(hashtag:, num_of_churps:)
    super
    @hashtag = hashtag
    @num_of_churps = num_of_churps
  end
end
