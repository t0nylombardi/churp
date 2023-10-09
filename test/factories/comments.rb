FactoryBot.define do
  factory :comment do
    content { "MyText" }
    tweet { nil }
    user { nil }
  end
end
