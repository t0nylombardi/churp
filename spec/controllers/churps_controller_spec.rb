# frozen_string_literal: true

require 'rails_helper'
require_relative '../support/devise'

RSpec.describe ChurpsController do
  describe 'GET /' do
    let(:user) { create(:user) }
    let(:valid_attributes) { { content: Faker::Lorem.sentence(word_count: 3), user_id: user.id } }
    let(:invalid_attributes) { { content: '', user_id: user.id } }
    let(:valid_session) { {} }

    login_user

    describe 'GET #index' do
      it 'returns a success response' do
        Churp.create! valid_attributes
        get :index, params: { content: Faker::Lorem.sentence(word_count: 3) }

        expect(response).to be_successful
      end
    end

    describe 'POST #like' do
      let(:churp) { create(:churp) } # Assuming you have a Churp factory

      it 'creates a like for the current user' do
        expect do
          post :like, params: { churp_id: churp.id }
        end.to change(Like, :count).by(1)
      end

      it 'responds with Turbo Stream and updates the likes partial' do
        post :like, params: { churp_id: churp.id }, format: :turbo_stream

        expect(response).to have_http_status(200)
        expect(response).to render_template('churps/shared/_likes')
        expect(response).to render_template('churps/shared/_likes', locals: { churp: })
      end

      it 'redirects to churps_path for HTML format' do
        post :like, params: { churp_id: churp.id }

        expect(response).to have_http_status(302)
        expect(response).to redirect_to(churps_path)
      end
    end

    describe 'POST #rechurp' do
      before do
        sign_in user
      end

      context 'when rechurp is successful' do
        let(:churp) { create(:churp) }

        it 'creates a rechurp' do
          expect do
            post :rechurp, params: { id: churp.id, churp: }
          end.to change(Churp, :count).by(1)
        end

        it 'increments the rechurp_count' do
          post :rechurp, params: { id: churp.id, churp: { content: 'foo' } }
          expect(assigns(:rechurp).rechurp_count).to eq(churp.rechurp_count + 1)
        end

        it 'redirects to churps_url' do
          post :rechurp, params: { id: churp.id, churp: { content: 'foo' } }
          expect(response).to redirect_to(churps_url)
        end
      end
    end
  end
end
