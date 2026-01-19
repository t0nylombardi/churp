# frozen_string_literal: true

# == Schema Information
#
# Table name: profiles
#
#  id          :uuid             not null, primary key
#  avatar      :jsonb            not null
#  birth_date  :datetime
#  cover       :jsonb            not null
#  description :text
#  first_name  :string
#  last_name   :string
#  theme       :integer          default(0)
#  theme_color :integer          default(0)
#  website     :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :uuid             not null
#
# Indexes
#
#  index_profiles_on_avatar   (avatar) USING gin
#  index_profiles_on_cover    (cover) USING gin
#  index_profiles_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :profile do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    description { Faker::Lorem.sentence(word_count: 20) }
    website { "https://#{Faker::Internet.domain_name}" }
    birth_date { Faker::Date.birthday(min_age: 18, max_age: 65) }
    association :user

    trait :with_avatar do
      after(:build) do |profile|
        profile.avatar = {
          url: "https://example.com/avatar.png",
          storage: "cdn"
        }
      end
    end
  end
end
