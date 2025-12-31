# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  display_name    :string
#  email           :string           default(""), not null
#  password_digest :string
#  role            :integer
#  slug            :string
#  username        :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_display_name  (display_name)
#  index_users_on_email         (email) UNIQUE
#  index_users_on_slug          (slug) UNIQUE
#  index_users_on_username      (username) UNIQUE
#
FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    password { "Passw0rd1!" }
    password_confirmation { "Passw0rd1!" }
    username { Faker::Internet.unique.username(specifier: 10) }

    factory :user_with_profile do
      after(:create) do |user|
        create(:profile, user:)
      end
    end
  end

  trait :with_profile do
    after(:create) do |user|
      create(:profile, user:)
    end
  end

  trait :admin do
    role { "admin" }
  end
end
