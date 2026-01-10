# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                  :uuid             not null, primary key
#  display_name        :string           default(""), not null
#  email               :string           default(""), not null
#  password_changed_at :datetime         not null
#  password_digest     :string           default(""), not null
#  role                :integer
#  slug                :string           default(""), not null
#  username            :string           default(""), not null
#  uuid                :uuid             not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_users_on_email     (email) UNIQUE
#  index_users_on_username  (username) UNIQUE
#  index_users_on_uuid      (uuid) UNIQUE
#
FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    password_digest { Authentication::Passwords::Hasher.hash("Password1234!") }
    username { Faker::Internet.unique.username(specifier: 10) }
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
