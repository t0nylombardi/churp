# frozen_string_literal: true

# == Schema Information
#
# Table name: hash_tags
#
#  id          :uuid             not null, primary key
#  name        :string
#  usage_count :integer          default(0), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_hash_tags_on_name  (name) UNIQUE
#
FactoryBot.define do
  factory :hash_tag do
    name { "##{Faker::Lorem.word}" }
  end
end
