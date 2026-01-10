# frozen_string_literal: true

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
require "rails_helper"

RSpec.describe Rechurp do
  describe "associations" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:original_churp).class_name("Churp") }
  end

  describe "counter cache" do
    it "increments original churp rechurps_count" do
      user = create(:user)
      original = create(:churp)

      expect do
        create(:rechurp, user:, original_churp: original)
      end.to change { original.reload.rechurps_count }.by(1)
    end
  end
end
