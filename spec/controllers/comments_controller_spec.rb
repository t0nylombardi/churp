# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommentsController do
  let(:user) { create(:user) }
  let(:churp) { create(:churp) }
  let(:comment) { create(:comment, user:, churp:) }

  before { sign_in user }

  describe 'GET #index' do
    it 'returns a success response' do
      get churp_comments_path(user, churp)
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    let(:comment) { create(:comment, churp:, user:) }

    it 'returns a success response' do
      get :show, params: { id: comment.to_param }
      expect(response).to be_successful
    end
  end

  describe 'GET #new' do
    it 'returns a success response' do
      get :new, params: { churp_id: churp.id }
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    let(:valid_attributes) { { content: 'Great comment', churp_id: churp.id } }
    let(:invalid_attributes) { { content: '', churp_id: churp.id } }

    context 'with valid parameters' do
      it 'creates a new Comment' do
        expect do
          post :create, params: { churp_id: churp.id, comment: valid_attributes }
        end.to change(Comment, :count).by(1)
      end

      it 'redirects to the churp' do
        post :create, params: { churp_id: churp.id, comment: valid_attributes }
        expect(response).to redirect_to(churp_path(churp))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Comment' do
        expect do
          post :create, params: { churp_id: churp.id, comment: invalid_attributes }
        end.to_not change(Comment, :count)
      end

      it 'redirects back with an alert message' do
        post :create, params: { churp_id: churp.id, comment: invalid_attributes }
        expect(response).to redirect_to(churp_path(churp))
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested comment' do
      comment # Ensure the comment is created before testing deletion
      expect do
        delete :destroy, params: { churp_id: churp.id, id: comment.id }
      end.to change(Comment, :count).by(-1)
    end

    it 'redirects to the churp' do
      delete :destroy, params: { churp_id: churp.id, id: comment.id }
      expect(response).to redirect_to(churp_path(churp))
    end
  end
end
