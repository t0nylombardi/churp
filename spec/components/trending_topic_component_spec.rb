# frozen_string_literal: true

require "rails_helper"

RSpec.describe TrendingTopicComponent, type: :component do
  describe "initialization" do
    let(:hashtag_name) { "johnwick" }
    let(:hashtag_content) { "I love #johnwick and his dog" }

    let(:churp) { create(:churp, content: hashtag_content) }

    let(:rendered_component) do
      render_inline(described_class.new(hashtag: hashtag_name, num_of_churps: 1))
    end

    it "renders the trending topic container" do
      expect(rendered_component.css(".trending-topic")).to be_present
    end

    it "displays the correct hashtag" do
      expect(rendered_component.text).to include("#johnwick")
    end

    it "shows the correct number of churps" do
      expect(rendered_component.css(".num-of-churps").text).to include("1")
    end
  end
end
