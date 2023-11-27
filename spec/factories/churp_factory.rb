# frozen_string_literal: true

# == Schema Information
#
# Table name: churps
#
#  id            :bigint           not null, primary key
#  rechurp_count :integer          default(0)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  churp_id      :integer
#  user_id       :bigint           not null
#
# Indexes
#
#  index_churps_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

FactoryBot.define do
  factory :churp do
    content { Faker::Lorem.paragraph_by_chars(number: 256, supplemental: false) }
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
