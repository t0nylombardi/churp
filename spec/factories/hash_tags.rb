# frozen_string_literal: true

# == Schema Information
#
# Table name: hash_tags
#
#  id         :uuid             not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :hash_tag do
    name { "##{Faker::Lorem.word}" }
  end
end
