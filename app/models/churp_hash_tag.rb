# frozen_string_literal: true

# == Schema Information
#
# Table name: churp_hash_tags
#
#  id          :uuid             not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  churp_id    :uuid
#  hash_tag_id :uuid
#
# Indexes
#
#  index_churp_hash_tags_on_churp_id                  (churp_id)
#  index_churp_hash_tags_on_churp_id_and_hash_tag_id  (churp_id,hash_tag_id) UNIQUE
#  index_churp_hash_tags_on_hash_tag_id               (hash_tag_id)
#
class ChurpHashTag < ApplicationRecord
  belongs_to :churp
  belongs_to :hash_tag
end
