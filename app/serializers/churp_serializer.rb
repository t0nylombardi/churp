# == Schema Information
#
# Table name: churps
#
#  id            :uuid             not null, primary key
#  body          :text
#  rechurp_count :integer          default(0), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  churp_id      :uuid             not null
#  user_id       :uuid             not null
#
# Indexes
#
#  index_churps_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class ChurpSerializer
  include JSONAPI::Serializer

  attributes :churp_id, :body, :created_at
end
