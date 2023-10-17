FactoryBot.define do
  factory :view do
    user_id { nil }
    tweet_id { nil }
    ip_address { "MyString" }
    user_agent { "MyString" }
    city { "MyString" }
    state { "MyString" }
  end
end
