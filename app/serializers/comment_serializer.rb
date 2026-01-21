# frozen_string_literal: true

# == Schema Information
#
# Table name: comments
#
#  id         :uuid             not null, primary key
#  content    :jsonb            not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  churp_id   :uuid             not null
#  user_id    :uuid             not null
#
# Indexes
#
#  index_comments_on_churp_id  (churp_id)
#  index_comments_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (churp_id => churps.id)
#  fk_rails_...  (user_id => users.id)
#
class CommentSerializer
  include JSONAPI::Serializer

  set_type :comment

  attributes :content, :created_at

  attribute :user do |object|
    user = object.user

    {
      id: user.id,
      username: user.username,
      display_name: user.display_name
    }
  end
end
