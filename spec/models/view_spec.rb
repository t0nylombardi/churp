# == Schema Information
#
# Table name: views
#
#  id         :bigint           not null, primary key
#  city       :string
#  ip_address :string
#  state      :string
#  user_agent :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  churp_id   :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_views_on_churp_id  (churp_id)
#  index_views_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (churp_id => churps.id)
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe View, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
