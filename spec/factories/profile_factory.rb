FactoryBot.define do
  factory :profile do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    description { Faker::Lorem.sentence(word_count: 20) }
    website { "https://#{Faker::Internet.domain_name}" }
    birth_date { Faker::Date.birthday(min_age: 18, max_age: 65) }
  end
end
