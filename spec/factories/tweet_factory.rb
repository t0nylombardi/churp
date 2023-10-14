# frozen_string_literal: true

FactoryBot.define do
  factory :tweet do
    body { Faker::Lorem.paragraph_by_chars(number: 256, supplemental: false) }
    user
  end

  trait :with_attachment do
    after(:build) do |tweet|
      tweet.churp_pic.attach(
        io: File.open(Rails.root.join('spec', 'fixtures', 'images', 'churp.jpeg')),
        filename: 'churp.jpeg',
        content_type: 'image/jpeg'
      )
    end
  end

  trait :retweet do
    tweet_id { tweet.id }
  end
end
