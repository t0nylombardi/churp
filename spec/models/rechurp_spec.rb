# == Schema Information
#
# Table name: rechurps
#
#  id                :uuid             not null, primary key
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  original_churp_id :uuid             not null
#  user_id           :uuid             not null
#
# Indexes
#
#  index_rechurps_on_original_churp_id                 (original_churp_id)
#  index_rechurps_on_original_churp_id_and_created_at  (original_churp_id,created_at)
#  index_rechurps_on_user_id                           (user_id)
#  index_rechurps_on_user_id_and_created_at            (user_id,created_at)
#
# Foreign Keys
#
#  fk_rails_...  (original_churp_id => churps.id)
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Rechurp, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
