# frozen_string_literal: true

require 'rails_helper'
require_relative '../support/devise'

RSpec.describe ChurpsController do
  describe 'GET /' do
    let(:user) { create(:user) }
    let(:valid_attributes) { { body: Faker::Lorem.sentence(word_count: 3), user_id: user.id } }
    let(:valid_session) { {} }

    login_user

    describe 'GET #index' do
      it 'returns a success response' do
        Churp.create! valid_attributes
        get :index, params: {}, session: valid_session

        expect(response).to be_successful
      end
    end
  end
end
