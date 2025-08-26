# frozen_string_literal: true

require "rails_helper"

RSpec.describe Search::SearchBarComponent, type: :component do
  subject(:rendered) { render_inline(described_class.new) }

  it "renders the form with correct attributes" do
    expect(rendered).to have_selector("form[action='/search'][method='get']")
  end

  it "renders the form container div" do
    expect(rendered).to have_selector("div.relative.m-2")
  end

  it "renders the search icon container" do
    expect(rendered).to have_selector("div.absolute.text-gray-600.flex.items-center.pl-4.h-full.cursor-pointer")
  end

  it "renders the mail icon" do
    expect(rendered).to have_selector("svg.icon.icon-tabler.icon-tabler-mail[width='18'][height='18']")
  end

  it "renders the input with expected attributes" do
    expect(rendered).to have_selector("input[type='text'][name='q']")
  end
end
