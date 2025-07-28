# frozen_string_literal: true

require "rails_helper"

RSpec.describe ProfileComponents::Buttons::SocialCountComponent, type: :component do
  let(:count) { 500 }
  let(:content) { "Following" }

  it "renders count" do
    render_inline(described_class.new(count:).with_content(content))
    expect(rendered_content).to have_text "500"
  end

  it "renders content" do
    render_inline(described_class.new(count:).with_content(content))
    expect(rendered_content).to have_text "Following"
  end

  it "renders count with a K for thousands" do
    count = 5000
    content = "Followers"
    render_inline(described_class.new(count:).with_content(content))
    expect(rendered_content).to have_text "5K"
  end

  it "renders content for thousands" do
    count = 5000
    content = "Followers"
    render_inline(described_class.new(count:).with_content(content))
    expect(rendered_content).to have_text "Followers"
  end

  it "renders count with a M for millions" do
    count = 5_000_000
    render_inline(described_class.new(count:).with_content(content))
    expect(rendered_content).to have_text "5M"
  end

  it "renders content for millions" do
    count = 5_000_000
    render_inline(described_class.new(count:).with_content(content))
    expect(rendered_content).to have_text "Following"
  end

  it "renders count with a B for billions" do
    count = 5_000_000_000
    render_inline(described_class.new(count:).with_content(content))
    expect(rendered_content).to have_text "5B"
  end

  it "renders content for billions" do
    count = 5_000_000_000
    render_inline(described_class.new(count:).with_content(content))
    expect(rendered_content).to have_text "Following"
  end

  it "renders count with a decimal" do
    count = 5_500_000
    render_inline(described_class.new(count:).with_content(content))
    expect(rendered_content).to have_text "5.5M"
  end

  it "renders content for decimal millions" do
    count = 5_500_000
    render_inline(described_class.new(count:).with_content(content))
    expect(rendered_content).to have_text "Following"
  end
end
