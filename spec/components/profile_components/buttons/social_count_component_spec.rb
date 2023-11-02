# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProfileComponents::SocialCountComponent, type: :component do
  let(:count) { 500 }
  let(:content) { 'Following' } 

  it "renders count" do
    render_inline(described_class.new(count: count).with_content(content))

    expect(rendered_content).to have_text "500"
    expect(rendered_content).to have_text "Following"
  end
  
  it "renders count with a K for thousands" do
    count = 5000
    content = 'Followers'
    render_inline(described_class.new(count: count).with_content(content))

    expect(rendered_content).to have_text "5K"
    expect(rendered_content).to have_text "Followers"
  end
  
  it "renders count with a M for millions" do
    count = 5_000_000
    render_inline(described_class.new(count: count).with_content(content))

    expect(rendered_content).to have_text "5M"
    expect(rendered_content).to have_text "Following"
  end
  
  it "renders count with a B for billions" do
    count = 5_000_000_000
    render_inline(described_class.new(count: count).with_content(content))

    expect(rendered_content).to have_text "5B"
    expect(rendered_content).to have_text "Following"
  end
  
  it "renders count with a decimal" do
    count = 5_500_000
    render_inline(described_class.new(count: count).with_content(content))

    expect(rendered_content).to have_text "5.5M"
    expect(rendered_content).to have_text "Following"
  end

end
