# frozen_string_literal: true

require "rails_helper"

RSpec.describe Churps::Hashtags::Processor do
  let_it_be(:churp) { Struct.new(:content).new({ "text" => "hello #ruby" }) }
  let(:old_body) { { "text" => "hello #rails" } }
  let(:processor) { described_class.new }

  describe "#call" do
    it "returns Success(:no_tags) when no hashtags are added" do
      allow(Churps::Hashtags::Parser).to receive(:call).and_return([])
      allow(Churps::Hashtags::Diff).to receive(:call).and_return({ added: [] })

      expect(Churps::Hashtags::Resolver).not_to receive(:call)

      result = processor.call(churp: churp)

      expect(result).to be_success
      expect(result.value!).to eq(:no_tags)
    end

    it "parses both old and new bodies when old_body is provided" do
      allow(Churps::Hashtags::Parser).to receive(:call).with("hello #ruby").and_return([])
      allow(Churps::Hashtags::Parser).to receive(:call).with("hello #rails").and_return([])
      allow(Churps::Hashtags::Diff).to receive(:call).and_return({ added: [] })

      processor.call(churp: churp, old_body: old_body)
    end

    it "resolves, persists, and indexes when hashtags are added" do
      hashtag = Churps::Hashtags::Hashtag.new(name: "ruby", start_index: 6, end_index: 11)
      resolved = { "ruby" => instance_double(HashTag) }

      allow(Churps::Hashtags::Parser).to receive(:call).and_return([hashtag])
      allow(Churps::Hashtags::Diff).to receive(:call).and_return({ added: [hashtag] })
      allow(Churps::Hashtags::Resolver).to receive(:call).with([hashtag]).and_return(resolved)

      expect(Churps::Hashtags::Persister).to receive(:call).with(churp: churp, resolved_map: resolved)
      expect(Churps::Hashtags::Indexer).to receive(:call).with(resolved.values)

      result = processor.call(churp: churp)

      expect(result).to be_success
      expect(result.value!).to eq(resolved.values)
    end

    it "returns Failure when hashtag validation fails" do
      allow(Churps::Hashtags::Parser)
        .to receive(:call)
        .and_raise(
          Dry::Types::ConstraintError.new(
            Churps::Hashtags::Types::TagName,
            "###bad"
          )
        )

      result = processor.call(churp: churp)

      expect(result).to be_failure
    end
  end
end
