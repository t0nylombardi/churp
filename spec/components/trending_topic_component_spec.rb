# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TrendingTopicComponent, type: :component do
  # Example 1: Testing the initialization of the component
  describe 'initialization' do
    let(:hashtag) { 'johnwick' }
    let(:num_of_churps) { 10 }

    it 'is initialized with the correct values' do
      component = render_inline(described_class.new(hashtag:, num_of_churps:))
      expect(component.css('.trending-topic')).to be_present
      expect(component.css('.trending-topic').text).to include(hashtag)
      expect(component.css('.num-of-churps').text).to include(num_of_churps.to_s)
    end
  end
end
