# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Search::SearchBarComponent, type: :component do
  it 'renders the search bar form with the correct attributes' do
    rendered = render_inline(Search::SearchBarComponent.new)

    expect(rendered).to have_selector("form[action='/search'][method='get'][data-local='true']") do |form|
      expect(form).to have_selector('div.relative.m-2') do |div|
        expect(div).to have_selector('div.absolute.text-gray-600.flex.items-center.pl-4.h-full.cursor-pointer') do |icon_div|
          expect(icon_div).to have_selector("svg.icon.icon-tabler.icon-tabler-mail[width='18'][height='18']")
        end

        expect(div).to have_selector("input[type='text'][name='q'][value=''][class='w-full px-3 bg-gray-200 dark:bg-dim-400 border-gray-200 dark:border-dim-400 text-gray-100 focus:bg-gray-100 dark:focus:bg-dim-900 focus:outline-none focus:border focus:ring-vividSkyBlue font-normal h-9 flex items-center pl-12 text-sm rounded-full border shadow'][placeholder='Search Churp']")
      end
    end
  end
end
