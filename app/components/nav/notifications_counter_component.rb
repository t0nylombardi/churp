# frozen_string_literal: true

class Nav::NotificationsCounterComponent < ViewComponent::Base
  def initialize(user:, count:)
    super
    @user = user
    @count = count
  end

  def counter
    return @count if @count <= 20

    "#{@count}+"
  end
end
