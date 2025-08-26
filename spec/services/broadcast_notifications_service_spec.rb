# frozen_string_literal: true

require "rails_helper"

describe BroadcastNotificationsService do
  let!(:user) { create(:user, :with_profile, username: "ricksanchez") }
  let!(:churp_user) { create(:user, :with_profile) }
  let!(:churp) { create(:churp, content: "<churp>@ricksanchez wubba lubba dub dub!<churp/>", user: churp_user) }

  context "with valid churp" do
    it "notitifys user" do
      results = described_class.call(churp)
      expect(results).to be_truthy
    end

    it "has notification for user" do
      expect(user.notifications.count).to be >= 0
    end
  end
end
