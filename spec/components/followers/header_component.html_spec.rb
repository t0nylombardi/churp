# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Followers::HeaderComponent, type: :component do
  context 'with view header component' do
    let(:view) { nil }
    let(:followers) { nil }
    let(:following) { nil }

    it 'renders header if view are not nil' do
      view = :verified_user
      render_inline(described_class.new(view:, followers:, following:))

      expect(rendered_content).to have_text('Verified User')
      expect(rendered_content).to have_css('hr')
    end

    it 'renders header if followers is not nil' do
      followers = build_list(:user, 5)
      render_inline(described_class.new(view:, followers:, following:))

      expect(rendered_content).to have_text('Followers')
      expect(rendered_content).to_not have_css('hr')
    end

    it 'renders header if following is not nil' do
      following = build_list(:user, 4)
      render_inline(described_class.new(view:, followers:, following:))

      expect(rendered_content).to have_text('Following')
      expect(rendered_content).to_not have_css('hr')
    end
  end
end
