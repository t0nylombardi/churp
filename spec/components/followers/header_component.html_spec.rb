# frozen_string_literal: true

require "rails_helper"

RSpec.describe Followers::HeaderComponent, type: :component do
  context "with view header component" do
    let(:view) { nil }
    let(:followers) { nil }
    let(:following) { nil }

    it "renders header text if view is not nil" do
      view = :verified_user
      render_inline(described_class.new(view:, followers:, following:))
      expect(rendered_content).to have_text("Verified User")
    end

    it "renders hr if view is not nil" do
      view = :verified_user
      render_inline(described_class.new(view:, followers:, following:))
      expect(rendered_content).to have_css("hr")
    end

    it "renders header text if followers is not nil" do
      followers = build_list(:user, 5)
      render_inline(described_class.new(view:, followers:, following:))
      expect(rendered_content).to have_text("Followers")
    end

    it "does not render hr if followers is not nil" do
      followers = build_list(:user, 5)
      render_inline(described_class.new(view:, followers:, following:))
      expect(rendered_content).not_to have_css("hr")
    end

    it "renders header text if following is not nil" do
      following = build_list(:user, 4)
      render_inline(described_class.new(view:, followers:, following:))
      expect(rendered_content).to have_text("Following")
    end

    it "does not render hr if following is not nil" do
      following = build_list(:user, 4)
      render_inline(described_class.new(view:, followers:, following:))
      expect(rendered_content).not_to have_css("hr")
    end
  end
end
