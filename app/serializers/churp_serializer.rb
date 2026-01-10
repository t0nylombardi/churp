# frozen_string_literal: true

class ChurpSerializer
  include JSONAPI::Serializer

  set_type :churp

  attributes :content, :created_at
  attribute :churp_type
  attribute :rechurps_count
  attribute :like_count do |object|
    object.likes.size
  end

  attribute :user do |object|
    user = object.user

    {
      id: user.id,
      username: user.username,
      display_name: user.display_name
    }
  end
end
