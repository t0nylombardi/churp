# frozen_string_literal: true

RSpec.describe Churps::Hashtags::ProcessJob do
  let(:churp) { create(:churp) }

  it "calls the processor with the churp" do
    processor = instance_double(Churps::Hashtags::Processor)

    allow(Churps::Hashtags::Processor)
      .to receive(:new)
      .and_return(processor)

    allow(processor).to receive(:call)

    described_class.perform_now(churp.id)

    expect(processor).to have_received(:call)
  end

  it "does nothing if churp is missing" do
    expect {
      described_class.perform_now(SecureRandom.uuid)
    }.not_to raise_error
  end
end
