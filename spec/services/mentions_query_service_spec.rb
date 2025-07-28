# frozen_string_literal: true

require 'rails_helper'

describe MentionsQueryService do
  describe 'with Call' do
    context 'when searching for usernames' do
      # need a large enough dataset to get a good result back from searchkick/elasticSearch
      let(:usernames) do
        %w[Rick Rick Ricky Dick Nick Rickii Rico Yick Ricki Rock Crick Gick Irick Rice Rich Rico Rieck Riek Rinck Rink
           Risk]
      end
      let(:query) { 'ick' }

      before do
        usernames.each_with_index do |name, idx|
          FactoryBot.create(:user, username: "#{name}#{idx}")
        end
      end

      it 'when query is given' do
        results = described_class.call!(query:)

        expect(results.success).to be_truthy
      end

      it 'when query is empty' do
        results = described_class.call!(query: nil)

        expect(results.success).to be_truthy
      end
    end
  end
end
