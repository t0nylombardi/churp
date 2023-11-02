# == Schema Information
#
# Table name: comments
#
#  id         :bigint           not null, primary key
#  content    :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  churp_id   :bigint           not null
#  user_id    :bigint           not null
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
class Comment < ApplicationRecord
  belongs_to :churp
  belongs_to :user

  scope :recent_comments, -> { order('created_at DESC') }
end
