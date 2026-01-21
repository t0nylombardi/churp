# frozen_string_literal: true

# == Schema Information
#
# Table name: profiles
#
#  id          :uuid             not null, primary key
#  avatar      :jsonb            not null
#  birth_date  :datetime
#  cover       :jsonb            not null
#  description :text
#  first_name  :string
#  last_name   :string
#  theme       :integer          default(0)
#  theme_color :integer          default(0)
#  website     :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :uuid             not null
#
# Indexes
#
#  index_profiles_on_avatar   (avatar) USING gin
#  index_profiles_on_cover    (cover) USING gin
#  index_profiles_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

require "rails_helper"

RSpec.describe Profile, type: :model do
  subject(:profile) { build(:profile) }

  describe "associations" do
    it { is_expected.to belong_to(:user) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:description).is_at_most(300) }
    it { is_expected.to validate_length_of(:website).is_at_most(255) }
  end

  describe "#full_name" do
    it "returns combined first and last name" do
      profile.first_name = "Rick"
      profile.last_name = "Sanchez"

      expect(profile.full_name).to eq("Rick Sanchez")
    end
  end
end
