# frozen_string_literal: true

# == Schema Information
#
# Table name: churp_hash_tags
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  churp_id    :bigint
#  hash_tag_id :bigint
#
# Indexes
#
#  index_churp_hash_tags_on_churp_id     (churp_id)
#  index_churp_hash_tags_on_hash_tag_id  (hash_tag_id)
#
class ChurpHashTag < ApplicationRecord
  belongs_to :churp
  belongs_to :hash_tag
end
