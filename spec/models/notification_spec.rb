# frozen_string_literal: true

# == Schema Information
#
# Table name: notifications
#
#  id             :bigint           not null, primary key
#  params         :jsonb
#  read_at        :datetime
#  recipient_type :string           not null
#  type           :string           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  recipient_id   :bigint           not null
#
# Indexes
#
#  index_notifications_on_read_at    (read_at)
#  index_notifications_on_recipient  (recipient_type,recipient_id)
#

require "rails_helper"

RSpec.describe Notification do
  subject(:notification_instance) { described_class.new }

  let(:user) { create(:user) }

  describe "#unread_notifications" do
    let!(:unread_notification) { create(:notification, recipient: user, read_at: nil) }
    let!(:read_notification) { create(:notification, recipient: user, read_at: Time.current) }

    it "includes unread notifications" do
      expect(user.notifications.unread).to include(unread_notification)
    end

    it "excludes read notifications" do
      expect(user.notifications.unread).not_to include(read_notification)
    end
  end

  describe "#unread_notifications_count" do
    before do
      create_list(:notification, 3, recipient: user, read_at: nil)
      create(:notification, recipient: user, read_at: Time.current)
    end

    it "returns count of unread notifications" do
      expect(user.notifications.unread.count).to eq(3)
    end
  end
end
