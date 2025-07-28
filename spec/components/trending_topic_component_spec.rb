# frozen_string_literal: true

require "rails_helper"

RSpec.describe TrendingTopicComponent, type: :component do
  # Example 1: Testing the initialization of the component
  describe "initialization" do
    let(:hashtag) { "johnwick" }
    let(:num_of_churps) { 10 }
    let(:component) { described_class.new(hashtag:, num_of_churps:) }

    it "renders the trending topic container" do
      component = render_inline(component)
      expect(component.css(".trending-topic")).to be_present
    end

    it "displays the correct hashtag" do
      component = render_inline(component)
      expect(component.css(".trending-topic").text).to include(hashtag)
    end

    it "shows the correct number of churps" do
      component = render_inline(component)
      expect(component.css(".num-of-churps").text).to include(num_of_churps.to_s)
    end
  end
end
