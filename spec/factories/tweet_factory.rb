# frozen_string_literal: true

FactoryBot.define do
  factory :churp do
    body { Faker::Lorem.paragraph_by_chars(number: 256, supplemental: false) }
    user
  end

  trait :with_attachment do
    after(:build) do |churp|
      churp.churp_pic.attach(
        io: File.open(Rails.root.join('spec', 'fixtures', 'images', 'churp.jpeg')),
        filename: 'churp.jpeg',
        content_type: 'image/jpeg'
      )
    end
  end

  trait :rechurp do
    churp_id { churp.id }
  end
end
