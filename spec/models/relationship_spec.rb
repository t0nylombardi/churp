# frozen_string_literal: true

# == Schema Information
#
# Table name: relationships
#
#  id          :uuid             not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  followed_id :uuid             not null
#  follower_id :uuid             not null
#
# Indexes
#
#  index_relationships_on_followed_id                  (followed_id)
#  index_relationships_on_follower_id                  (follower_id)
#  index_relationships_on_follower_id_and_followed_id  (follower_id,followed_id) UNIQUE
#
require "rails_helper"

RSpec.describe Relationship do
  pending "add some examples to (or delete) #{__FILE__}"
end
