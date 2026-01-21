# frozen_string_literal: true

# == Schema Information
#
# Table name: churps
#
#  id                :uuid             not null, primary key
#  content           :jsonb            not null
#  rechurps_count    :integer          default(0), not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  original_churp_id :uuid
#  user_id           :uuid             not null
#
# Indexes
#
#  index_churps_on_original_churp_id  (original_churp_id)
#  index_churps_on_user_id            (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (original_churp_id => churps.id)
#  fk_rails_...  (user_id => users.id)
#

FactoryBot.define do
  factory :churp do
    content {
      {
        "version" => 1,
        "blocks" => [
          {
            "type" => "text",
            "content" => "hello churp"
          }
        ]
      }
    }
    user
  end

  trait :rechurp do
    after(:build) do |churp|
      churp.churp_id = create(:churp).id
    end
  end
end
