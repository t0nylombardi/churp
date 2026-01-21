# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    content {
      {
        "version" => 1,
        "blocks" => [
          { "type" => "text", "content" => "hello comment" }
        ]
      }
    }
    churp
    user
  end
end
