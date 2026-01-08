# == Schema Information
#
# Table name: churps
#
#  id                :uuid             not null, primary key
#  content           :jsonb            not null
#  rechurp_count     :integer          default(0), not null
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
class ChurpSerializer
  include JSONAPI::Serializer

  attributes :id, :content, :created_at

  attribute :churp_type do |object|
    object.churp_type
  end

  attribute :rechurp_count do |object|
    object.rechurp_count
  end

  attribute :like_count do |object|
    object.likes.count
  end

  attribute :user do |object|
    {
      id: object.user.id,
      username: object.user.username,
      display_name: object.user.display_name
    }
  end
end
