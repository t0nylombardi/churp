# frozen_string_literal: true

require "rails_helper"

RSpec.describe Followers::ActiveUnderlineComponent, type: :component do
  it "renders hr" do
    render_inline(described_class.new)

    expect(rendered_content).to have_css("hr")
  end
end
