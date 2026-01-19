# frozen_string_literal: true

# == Schema Information
#
# Table name: churp_mentions
#
#  id                :uuid             not null, primary key
#  end_index         :integer          not null
#  start_index       :integer          not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  churp_id          :uuid             not null
#  mentioned_user_id :uuid             not null
#
# Indexes
#
#  index_churp_mentions_on_churp_id_and_mentioned_user_id  (churp_id,mentioned_user_id) UNIQUE
#  index_churp_mentions_on_mentioned_user_id               (mentioned_user_id)
#
# Foreign Keys
#
#  fk_rails_...  (churp_id => churps.id) ON DELETE => cascade
#  fk_rails_...  (mentioned_user_id => users.id) ON DELETE => cascade
#
class ChurpMention < ApplicationRecord
  belongs_to :churp
  belongs_to :mentioned_user, class_name: "User"

  validates :start_index, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :end_index, presence: true, numericality: { greater_than: 0 }

  validates :mentioned_user_id, uniqueness: {
    scope: :churp_id,
    message: "has already been mentioned in this churp"
  }
end
