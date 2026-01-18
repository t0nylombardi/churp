# frozen_string_literal: true

require "rails_helper"

RSpec.describe Churps::Mentions::Processor do
  let(:churp) { Struct.new(:content).new({ "text" => "hello @alice" }) }
  let(:old_body) { { "text" => "hello @bob" } }

  before do
    stub_const("Churps::Mentions::ResolvedMentionBuilder", Class.new do
      def self.call(*); end
    end)
  end

  describe ".call" do
    it "returns nil when no mentions are added" do
      allow(Churps::Mentions::Parser).to receive(:call).and_return([])
      allow(Churps::Mentions::Diff).to receive(:call).and_return({ added: [] })

      expect(Churps::Mentions::Resolver).not_to receive(:call)
      expect(Churps::Mentions::ResolvedMentionBuilder).not_to receive(:call)

      expect(described_class.call(churp: churp)).to be_nil
    end

    it "parses both old and new bodies when old_body is provided" do
      allow(Churps::Mentions::Parser).to receive(:call).with("hello @alice").and_return([])
      allow(Churps::Mentions::Parser).to receive(:call).with("hello @bob").and_return([])
      allow(Churps::Mentions::Diff).to receive(:call).and_return({ added: [] })

      described_class.call(churp: churp, old_body: old_body)
    end

    it "resolves and builds when mentions are added" do
      mention = Churps::Mentions::Mention.new(
        username: "alice",
        start_index: 6,
        end_index: 12
      )
      resolved = { "alice" => "user-id" }

      allow(Churps::Mentions::Parser).to receive(:call).and_return([mention])
      allow(Churps::Mentions::Diff).to receive(:call).and_return({ added: [mention] })
      allow(Churps::Mentions::Resolver).to receive(:call).with([mention]).and_return(resolved)

      expect(Churps::Mentions::ResolvedMentionBuilder).to receive(:call).with(
        churp: churp,
        mentions: [mention],
        resolved_map: resolved
      )

      described_class.call(churp: churp)
    end
  end
end
