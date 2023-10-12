FactoryBot.define do
  factory :profile do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    description { Faker::Lorem.sentence(word_count: 20) }
    website { "https://#{Faker::Internet.domain_name}" }
    birth_date { Faker::Date.birthday(min_age: 18, max_age: 65) }

    after(:build) do |profile|
      profile.profile_bg.attach(
        io: File.open(Rails.root.join('spec', 'fixtures', 'images', 'twitter_bg.jpeg')),
        filename: 'twitter_bg.jpeg',
        content_type: 'image/jpeg'
      )

      profile.profile_pic.attach(
        io: File.open(Rails.root.join('spec', 'fixtures', 'images', 'stanley-roper-profile.png')),
        filename: 'twitter_bg.jpeg',
        content_type: 'image/jpeg'
      )
    end
  end
end
