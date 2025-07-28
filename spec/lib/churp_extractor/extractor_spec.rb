# frozen_string_literal: true

require 'rails_helper'

describe ChurpExtractor::Extractor do
  let!(:extractor) { described_class.new }

  describe 'with mentions' do
    context 'with single screen name alone' do
      it 'linked' do
        expect(extractor.extract_mentioned_screen_names('@alice')).to be == ['alice']
      end

      it 'links with _' do
        expect(extractor.extract_mentioned_screen_names('@alice_adams')).to be == ['alice_adams']
      end

      it 'links if numeric' do
        expect(extractor.extract_mentioned_screen_names('@1234')).to be == ['1234']
      end
    end

    context 'with multiple screen names' do
      it 'both linked' do
        expect(extractor.extract_mentioned_screen_names('@alice @bob')).to be == %w[alice bob]
      end
    end

    context 'when screen names embedded in text' do
      it 'linked in Latin text' do
        expect(extractor.extract_mentioned_screen_names('waiting for @alice to arrive')).to be == ['alice']
      end

      it 'linked in Japanese text' do
        expect(extractor.extract_mentioned_screen_names('の@aliceに到着を待っている')).to be == ['alice']
      end

      it 'ignore mentions preceded by !, @, #, $, %, & or *' do
        invalid_chars = ['!', '@', '#', '$', '%', '&', '*']
        invalid_chars.each do |c|
          expect(extractor.extract_mentioned_screen_names("f#{c}@kn")).to be == []
        end
      end
    end
  end

  describe 'mentions with indices' do
    context 'with single screen name alone' do
      it 'links and the correct indices' do
        expect(extractor.extract_mentioned_screen_names_with_indices('@alice')).to be == [{ screen_name: 'alice',
                                                                                            indices: [0, 6] }]
      end

      it 'linked with _ and the correct indices' do
        expect(extractor.extract_mentioned_screen_names_with_indices('@alice_adams')).to be == [{
          screen_name: 'alice_adams', indices: [0, 12]
        }]
      end

      it 'linked if numeric and the correct indices' do
        expect(extractor.extract_mentioned_screen_names_with_indices('@1234')).to be == [{ screen_name: '1234',
                                                                                           indices: [0, 5] }]
      end
    end

    context 'with multiple screen names' do
      it 'both are linked with the correct indices' do
        expect(extractor.extract_mentioned_screen_names_with_indices('@alice @bob')).to be == [{ screen_name: 'alice', indices: [0, 6] },
                                                                                               { screen_name: 'bob',
                                                                                                 indices: [7, 11] }]
      end

      it 'links with the correct indices even when repeated' do
        expect(extractor.extract_mentioned_screen_names_with_indices('@alice @alice @bob')).to be == [{ screen_name: 'alice', indices: [0, 6] },
                                                                                                      {
                                                                                                        screen_name: 'alice', indices: [
                                                                                                          7, 13
                                                                                                        ]
                                                                                                      },
                                                                                                      {
                                                                                                        screen_name: 'bob', indices: [
                                                                                                          14, 18
                                                                                                        ]
                                                                                                      }]
      end
    end
  end
end
