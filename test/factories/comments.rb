FactoryBot.define do
  factory :comment do
    content { "MyText" }
    churp { nil }
    user { nil }
  end
end
