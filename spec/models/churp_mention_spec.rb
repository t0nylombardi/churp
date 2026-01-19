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
require "rails_helper"

RSpec.describe ChurpMention, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
