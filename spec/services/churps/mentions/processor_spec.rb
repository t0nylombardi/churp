# frozen_string_literal: true

require "rails_helper"

RSpec.describe Churps::Mentions::Processor do
  subject(:processor) { described_class.new }

  let(:author) { create(:user, username: "@author") }
  let!(:mentioned) { create(:user, username: "@alice") }

  let(:churp) do
    create(
      :churp,
      user: author,
      content: {
        "version" => 1,
        "blocks" => [
          { "type" => "paragraph", "text" => "Hello @alice" }
        ]
      }
    )
  end

  describe "#call (unit behavior)" do
    it "returns Success(:no_mentions) when no mentions are added" do
      allow(Churps::ContentText).to receive(:extract).and_return("Hello @alice")
      allow(Churps::Mentions::Parser).to receive(:call).and_return([])
      allow(Churps::Mentions::Diff).to receive(:call).and_return({ added: [] })

      expect(Churps::Mentions::Resolver).not_to receive(:call)

      result = processor.call(churp: churp)

      expect(result).to be_success
      expect(result.value!).to eq(:no_mentions)
    end

    it "resolves, persists, and notifies when mentions are added" do
      mention = Churps::Mentions::Mention.new(
        username: "alice",
        start_index: 6,
        end_index: 12
      )

      resolved = { "alice" => mentioned.id }

      allow(Churps::ContentText).to receive(:extract).and_return("Hello @alice")
      allow(Churps::Mentions::Parser).to receive(:call).and_return([mention])
      allow(Churps::Mentions::Diff).to receive(:call).and_return({ added: [mention] })
      allow(Churps::Mentions::Resolver).to receive(:call).and_return(resolved)

      expect(Churps::Mentions::Persister)
        .to receive(:call)
        .with(churp: churp, mentions: [mention], resolved_map: resolved)

      expect(Churps::Mentions::Notifier)
        .to receive(:call)
        .with(churp: churp, mentions: [mention], resolved_map: resolved)

      result = processor.call(churp: churp)

      expect(result).to be_success
      expect(result.value!).to eq([mention])
    end
  end

  describe "#call (integration)" do
    it "creates mention records and notifications" do
      result = processor.call(churp: churp)

      expect(result).to be_success

      mention = ChurpMention.first
      expect(mention.churp_id).to eq(churp.id)
      expect(mention.mentioned_user).to eq(mentioned)

      notification = Notification.last
      expect(notification.recipient).to eq(mentioned)
      expect(notification.actor).to eq(author)
      expect(notification.event_type).to eq("mention")
      expect(notification.data["churp_id"]).to eq(churp.id)
    end
  end
end
