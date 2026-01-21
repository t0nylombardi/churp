# frozen_string_literal: true

# == Schema Information
#
# Table name: hash_tags
#
#  id          :uuid             not null, primary key
#  name        :string
#  usage_count :integer          default(0), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_hash_tags_on_name  (name) UNIQUE
#
require "rails_helper"

RSpec.describe HashTag do
  pending "add some examples to (or delete) #{__FILE__}"
end
